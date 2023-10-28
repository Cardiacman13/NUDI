#!/usr/bin/env bash

# openSUSE Nvidia Driver Installation Script
function opensuse() {
    echo "Starting Nvidia driver installation for openSUSE..."

    # Refreshing the repositories
    echo "Refreshing repositories..."
    zypper ref

    # Adding the Nvidia repository
    echo "Adding the Nvidia repository..."
    zypper addrepo --refresh https://download.nvidia.com/opensuse/leap/15.3 NVIDIA

    # Ensuring the repository is trusted
    echo "Ensuring the repository is trusted..."
    zypper --gpg-auto-import-keys ref

    # Installing the Nvidia drivers
    echo -e "Installing Nvidia drivers... ${RED}(Might be long)${RESET}"
    zypper install -y nvidia_drivers_G06 nvidia_drivers_G06_kmp_default nvidia_gl_G06 nvidia_gl_G06_32bit nvidia_utils_G06 nvidia_video_G06 nvidia_video_G06_32bit

    echo "Nvidia drivers installed successfully."
}
