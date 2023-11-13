#!/usr/bin/env bash

# Fedora Nvidia Driver Installation Script
function fedoraimmutable() {

    echo "|- Enabling RPM Fusion and installing Nvidia drivers."

    echo "  |- Enabling RPM Fusion Free and Non-Free repositories..."
    # Enable RPM Fusion (Free and Non-Free)
    rpm-ostree install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm > /dev/null 2>&1
    rpm-ostree install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm > /dev/null 2>&1

    echo -e "  |- Installing Nvidia drivers... ${RED}(Might be long)${RESET}"
    # Install the Nvidia drivers
    rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia 2>&1

    echo "  |- Editing grub options for Nvidia."
    sudo rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1 initcall_blacklist=simpledrm_platform_driver_init > /dev/null 2>&1
    rpm-ostree kargs --delete=nomodeset > /dev/null 2>&1
    
    echo "Nvidia drivers installed successfully."
}
