#!/usr/bin/env bash

# Function to configure the Nvidia hook by copying the nvidia.hook file to /etc/pacman.d/hooks/
function hook() {
    echo "|- Configuring the Nvidia hook."

    local hook_folder
    hook_folder="/etc/pacman.d/hooks/"
    local hook_file
    hook_file="nvidia.hook"
    local hook_src
    hook_src="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/data/nvidia.hook"
    
    # Create the hooks folder if not already done
    mkdir -p "${hook_folder}"

    # Copy the hook file
    if cp "${hook_src}" "${hook_folder}${hook_file}"; then
        echo -e "${GREEN}Nvidia hook configured successfully.${RESET}"
    else
        echo -e "${RED}Error configuring the Nvidia hook.${RESET}"
        exit 1
    fi
}

# Function to update the mkinitcpio configuration file to include the necessary NVIDIA modules.
function mkinitcpio() {
    echo "|- Configuring mkinitcpio."

    local mkinitcpio_src
    mkinitcpio_src="/etc/mkinitcpio.conf"
    
    # Add NVIDIA modules to mkinitcpio
    if sed -i '/MODULES=/ s/)/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' "${mkinitcpio_src}"; then
        echo -e "${GREEN}Mkinitcpio configuration successful.${RESET}"
    else
        echo -e "${RED}Error configuring mkinitcpio.${RESET}"
        exit 1
    fi
}

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
    pacman -Syy --noconfirm >> /dev/null 2>&1
    echo "|- Preconfiguration for Nvidia."
    local nvidia_wayland_conf
    nvidia_wayland_conf="/etc/modprobe.d/nvidia-wayland.conf"
    echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" | tee "${nvidia_wayland_conf}"

    bootloaders
    mkinitcpio
    hook

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
            pacman -S --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader >> /dev/null 2>&1
            echo -e "|- Installing CUDA. ${RED}(very long)${RESET}"
            pacman -S --needed --noconfirm cuda >> /dev/null 2>&1

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
            pacman -S --needed --noconfirm cuda >> /dev/null 2>&1

            echo "|- Enabling Nvidia services for hibernation, resume, and suspension."
            systemctl enable nvidia-{hibernate,resume,suspend} >> /dev/null 2>&1
            ;;

        *)
            echo "Unexpected error."
            ;;
    esac
}
