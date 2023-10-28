# Update system and install necessary packages
function debian() {
    echo "|- Updating system and installing Nvidia drivers."

    echo "  |- Adding 32-bit architecture support..."
    dpkg --add-architecture i386 > /dev/null 2>&1

    echo "  |- Updating package lists..."
    apt update > /dev/null 2>&1

    # Install software-properties-common if add-apt-repository is not available
    if ! command -v add-apt-repository >/dev/null 2>&1; then
        echo "  |- Installing software-properties-common..."
        apt install -y software-properties-common > /dev/null 2>&1
    fi

    echo "  |- Adding non-free and contrib repositories..."
    # Add non-free packages (required for Nvidia drivers)
    add-apt-repository non-free > /dev/null 2>&1
    add-apt-repository contrib > /dev/null 2>&1
    apt update > /dev/null 2>&1

    echo -e "  |- Installing Nvidia drivers and related packages... ${RED}(Might be long)${RESET}"
    # Install the Nvidia drivers along with 32-bit libraries and Vulkan tools
    apt install -y linux-headers-$(uname -r) build-essential dkms firmware-misc-nonfree nvidia-driver nvidia-driver-libs:i386 vulkan-tools vulkan-tools:i386 nvidia-cuda-dev nvidia-cuda-toolkit > /dev/null 2>&1

    echo "Nvidia drivers installed successfully."
}
