# Ubuntu Nvidia Driver Installation Script
function ubuntu() {
    echo "|- Updating system and installing Nvidia drivers."

    # Enable i386 architecture and update package lists
    echo "  |- Enabling i386 architecture..."
    dpkg --add-architecture i386 > /dev/null 2>&1

    echo "  |- Updating package lists..."
    apt update > /dev/null 2>&1

    # Install the latest version of Nvidia drivers and Vulkan libraries
    echo -e "  |- Installing the latest Nvidia drivers and Vulkan libraries... ${RED}(Might be long)${RESET}"
    apt install -y nvidia-driver-535 libvulkan1 libvulkan1:i386 > /dev/null 2>&1

    echo "Latest Nvidia drivers and Vulkan libraries installed successfully."
}
