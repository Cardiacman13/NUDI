#!/usr/bin/env bash

# openSUSE Tumbleweed Nvidia Driver Installation Script
function opensuse_tw() {
    echo "Starting Nvidia driver installation for openSUSE Tumbleweed..."

    # Refreshing the repositories
    echo "Refreshing repositories..."
    zypper ref > /dev/null 2>&1

    # Adding the Nvidia repository for Tumbleweed
    echo "Adding the Nvidia repository for Tumbleweed..."
    zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA > /dev/null 2>&1

    # Ensuring the repository is trusted
    echo "Ensuring the repository is trusted..."
    zypper --gpg-auto-import-keys ref > /dev/null 2>&1

    # Installing the Nvidia drivers
    echo -e "Installing Nvidia drivers... ${RED}(Might be long)${RESET}"
    zypper install --auto-agree-with-licenses -y nvidia-drivers-G06 nvidia-driver-G06-kmp-default nvidia-gl-G06 nvidia-gl-G06-32bit nvidia-utils-G06 nvidia-video-G06 nvidia-video-G06-32bit > /dev/null 2>&1

    echo "Cleaning Xorg configuration..."
    if [ -e /etc/X11/xorg.conf ]; then
        rm /etc/X11/xorg.conf > /dev/null 2>&1
    fi

    echo "Nvidia drivers installed successfully."
}
