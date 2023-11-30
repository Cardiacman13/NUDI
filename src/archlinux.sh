#!/usr/bin/env bash

function uninstall_one() {
    local -r package=$1
    sudo pacman -Rdd --noconfirm ${package} >> /dev/null 2>&1
}

function uninstall_lst() {
    local -r lst=$1
    local -r lst_split=(${lst// / })

    for package in ${lst_split[@]}; do
        uninstall_one "${package}"
    done
}

function nvidia_config() {
    if [ ! -f /etc/modprobe.d/nvidia.conf ]; then
        sudo touch /etc/modprobe.d/nvidia.conf
        echo -e 'options nvidia-drm modeset=1' | sudo tee -a /etc/modprobe.d/nvidia.conf
    fi     
}

function install_headers() {
    local kernel_headers=()

    for kernel in /boot/vmlinuz-*; do
        [ -e "${kernel}" ] || continue
        kernel_headers+=("$(basename "${kernel}" | sed -e 's/vmlinuz-//')-headers")
    done

    sudo pacman -S --noconfirm "${kernel_headers[*]}" >> /dev/null 2>&1
}

function archlinux() {
    
    echo "|- Updating system."
    pacman -Syu --needed --noconfirm >> /dev/null 2>&1
    
    echo "|- Installing headers."
    install_headers

    echo "|- Removing old dependencies."
    local -r unlst="
    nvidia
    nvidia-lts
    nvidia-dkms
    nvidia-settings
    nvidia-utils
    opencl-nvidia
    libvdpau
    lib32-libvdpau
    lib32-libvdpau
    lib32-nvidia-utils
    egl-wayland
    dxvk-nvapi-mingw
    libxnvctrl
    lib32-libxnvctrl
    vulkan-icd-loader
    lib32-vulkan-icd-loader
    lib32-opencl-nvidia
    opencl-headers
    lib32-nvidia-dev-utils-tkg
    lib32-opencl-nvidia-dev-tkg
    nvidia-dev-dkms-tkg
    nvidia-dev-egl-wayland-tkg
    nvidia-dev-settings-tkg
    nvidia-dev-utils-tkg
    opencl-nvidia-dev-tkg
"

    uninstall_lst "${unlst}"
    nvidia_config

    read -p "Choose between 'nvidia' (Recommended) or 'nvidia-all' (Note: If you choose nvidia-all, you must know how to maintain it):" choice

    choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')

    while [[ -z "$choice" || ! "$choice" =~ ^NVIDIA(-ALL)?$ ]]; do
        read -p "Invalid or empty option. Please choose 'nvidia' or 'nvidia-all':" choice
        choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')
    done

    case "${choice}" in
        "NVIDIA")
            echo -e "|- Installing Nvidia packages. ${RED}(long)${RESET}"
            pacman -S --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia >> /dev/null 2>&1
            ;;

        "NVIDIA-ALL")
            echo -e "|- Installing nvidia-all. ${RED}(long)${RESET}"
            git clone https://github.com/Frogging-Family/nvidia-all.git >> /dev/null 2>&1
            cd nvidia-all  || exit
            makepkg -si
            cd .. || exit
            rm -rf nvidia-all >> /dev/null 2>&1
            ;;

        *)
            echo "Unexpected error."
            ;;
    esac
}
