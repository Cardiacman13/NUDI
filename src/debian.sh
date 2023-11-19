#!/usr/bin/env bash

# Update system and install necessary packages
function debian() {
    echo "|- Updating system and installing Nvidia drivers."

    # In case apt sources still have cdrom as source
    echo "  |- Cleaning-up sources.list..."
    sed -i 's/deb cdrom:/#deb cdrom:/g' /etc/apt/sources.list

    echo "  |- Adding 32-bit architecture support..."
    dpkg --add-architecture i386 > /dev/null 2>&1

    echo "  |- Updating package lists..."
    apt update -y > /dev/null 2>&1

    # Install software-properties-common if add-apt-repository is not available
    if ! command -v add-apt-repository > /dev/null; then
        echo "  |- Installing software-properties-common..."
        apt install -y software-properties-common > /dev/null 2>&1
    fi

    echo "  |- Adding non-free and contrib repositories..."
    # Add non-free packages (required for Nvidia drivers)
    add-apt-repository -y non-free > /dev/null 2>&1
    add-apt-repository -y non-free-firmware > /dev/null 2>&1
    add-apt-repository -y contrib > /dev/null 2>&1
    apt update -y > /dev/null 2>&1

    echo -e "  |- Installing Nvidia drivers and related packages... ${RED}(Might be long)${RESET}"
    # Install the Nvidia drivers along with 32-bit libraries and Vulkan tools
    apt install -y linux-headers-amd64 build-essential dkms firmware-misc-nonfree libglvnd-dev pkg-config nvidia-driver nvidia-driver-libs:i386 vulkan-tools libnvoptix1 > /dev/null 2>&1

    
    echo -e "  |- Installing drm-modeset=1 configuration..."

    if [[ -f /etc/modprobe.d/nvidia.conf ]]; then
        rm /etc/modprobe.d/nvidia.conf
    fi
    touch /etc/modprobe.d/nvidia.conf
    echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia.conf

    echo "Nvidia drivers installed successfully."
}
