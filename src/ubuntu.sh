#!/usr/bin/env bash

# Ubuntu Nvidia Driver Installation Script
function ubuntu() {
    echo "|- Updating system and installing Nvidia drivers."

    # In case apt sources still have cdrom as source
    echo "  |- Cleaning-up sources.list..."
    sed -i 's/deb cdrom:/#deb cdrom:/g' /etc/apt/sources.list

    # Enable i386 architecture and update package lists
    echo "  |- Enabling i386 architecture..."
    dpkg --add-architecture i386 > /dev/null 2>&1

    echo "  |- Updating package lists..."
    apt update -y > /dev/null 2>&1

    # Install the latest version of Nvidia drivers and Vulkan libraries
    echo -e "  |- Installing the latest Nvidia drivers and Vulkan libraries... ${RED}(Might be long)${RESET}"
    apt_search=$(apt-cache search 'nvidia-driver-')
    nvidia_latest=$(echo "$apt_search" | awk -F '[- ]' '/nvidia-driver-/ { if ($3 > max) max = $3 } END { print max }')
    apt install -y nvidia-driver-"$nvidia_latest" libvulkan1 libvulkan1:i386 > /dev/null 2>&1

    echo "Latest Nvidia drivers and Vulkan libraries installed successfully."
}
