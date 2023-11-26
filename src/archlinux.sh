#!/usr/bin/env bash

# Function to detect the bootloader used by the system and add the "nvidia-drm.modeset=1" option to the boot configuration.
function bootloaders() {
    echo "|- Detecting the bootloader."

    local boot_loader
    if [[ -d "/boot/loader/entries" ]]; then
        boot_loader="systemd-boot"
    else
        boot_loader="grub"
    fi

    echo "|- Detected bootloader: ${boot_loader}"

    if [[ "${boot_loader}" == "grub" ]]; then
        local boot_loader_src="/etc/default/grub"

        # Add the nvidia-drm.modeset=1 option for GRUB
        if grep -q "GRUB_CMDLINE_LINUX_DEFAULT" "${boot_loader_src}" && ! grep -q "nvidia-drm.modeset=1" "${boot_loader_src}"; then
            echo "   |- Adding nvidia-drm.modeset=1 to boot options for GRUB."
            sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/ s/\"$/ nvidia-drm.modeset=1\"/' "${boot_loader_src}"
        fi

        # Update GRUB
        echo "|- Updating grub."
        if ! grub-mkconfig -o /boot/grub/grub.cfg >> /dev/null 2>&1; then
            echo -e "${RED}Error updating GRUB.${RESET}"
            exit 1
        fi
    else
        local boot_loader_src="/boot/loader/entries/*.conf"
        echo "|- Adding nvidia-drm.modeset=1 to boot options for systemd-boot."
        if ! sed -i '/^options/ s/$/ nvidia-drm.modeset=1/' ${boot_loader_src}; then
            echo -e "${RED}Error adding boot option for systemd-boot.${RESET}"
            exit 1
        fi
    fi
}

# Function to install Nvidia drivers.
function archlinux() {
    echo "|- Update system."
    pacman -Syu --noconfirm >> /dev/null 2>&1
    echo "|- Preconfiguration for Nvidia."
    local nvidia_wayland_conf
    nvidia_wayland_conf="/etc/modprobe.d/nvidia-wayland.conf"
    echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" | tee "${nvidia_wayland_conf}"

    bootloaders

    # Use a while loop to continue prompting the user until a valid choice is made
    read -p "Choose between 'nvidia' (Recommended) or 'nvidia-all' (Note: If you choose nvidia-all, you must know how to maintain it):" choice

    choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')  # Convert input to uppercase.

    while [[ -z "$choice" || ! "$choice" =~ ^NVIDIA(-ALL)?$ ]]; do
        read -p "Invalid or empty option. Please choose 'nvidia' or 'nvidia-all':" choice
        choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')
    done

    case "${choice}" in
        "NVIDIA")
            echo -e "|- Installing Nvidia packages. ${RED}(long)${RESET}"
            pacman -S --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia >> /dev/null 2>&1
            echo -e "|- Installing CUDA. ${RED}(very long)${RESET}"

            echo "|- Enabling Nvidia services for hibernation, resume, and suspension."
            systemctl enable nvidia-{hibernate,resume,suspend} >> /dev/null 2>&1
            ;;

        "NVIDIA-ALL")
            pacman -Rdd --noconfirm egl-wayland >> /dev/null 2>&1
            echo -e "|- Installing nvidia-all. ${RED}(long)${RESET}"
            git clone https://github.com/Frogging-Family/nvidia-all.git >> /dev/null 2>&1
            cd nvidia-all  || exit
            makepkg -si
            cd .. || exit
            rm -rf nvidia-all >> /dev/null 2>&1
            echo -e "|- Installing CUDA. ${RED}(very long)${RESET}"

            echo "|- Enabling Nvidia services for hibernation, resume, and suspension."
            systemctl enable nvidia-{hibernate,resume,suspend} >> /dev/null 2>&1
            ;;

        *)
            echo "Unexpected error."
            ;;
    esac
}
