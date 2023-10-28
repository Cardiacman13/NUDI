#!/usr/bin/env bash

# Fedora Nvidia Driver Installation Script
function fedora() {
    echo "|- Enabling RPM Fusion and installing Nvidia drivers."

    echo "  |- Enabling RPM Fusion Free and Non-Free repositories..."
    # Enable RPM Fusion (Free and Non-Free)
    dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm > /dev/null 2>&1
    dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm > /dev/null 2>&1

    echo "  |- Updated package lists..."
    # Update package lists
    dnf check-update > /dev/null 2>&1

    echo -e "  |- Installing Nvidia drivers... ${RED}(Might be long)${RESET}"
    # Install the Nvidia drivers
    dnf install -y akmod-nvidia > /dev/null 2>&1

    echo -e "  |- Forcing the build of kernel modules... ${RED}(Might be long)${RESET}"
    # Force the build of kernel modules
    akmods > /dev/null 2>&1

    echo -e "  |- Installing CUDA, 32-bit support and related packages... ${RED}(Might be long)${RESET}"
    # Optional: Install 32-bit support for 64-bit systems, useful for some games and applications
    dnf install -y xorg-x11-drv-nvidia-cuda libs wine-dxvk vulkan-tools > /dev/null 2>&1
    dnf install -y xorg-x11-drv-nvidia-cuda-libs.i686 > /dev/null 2>&1

    echo "Latest Nvidia drivers installed successfully."

    echo "|- Rebuilding initramfs."

    echo -e "  |- Rebuilding initramfs... ${RED}(Might be long)${RESET}"
    dracut --force > /dev/null 2>&1

    echo "Nvidia drivers installed successfully."
}
