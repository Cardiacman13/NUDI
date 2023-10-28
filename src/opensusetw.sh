# openSUSE Tumbleweed Nvidia Driver Installation Script
function opensuse_tw() {
    echo "Starting Nvidia driver installation for openSUSE Tumbleweed..."

    # Refreshing the repositories
    echo "Refreshing repositories..."
    sudo zypper ref

    # Adding the Nvidia repository for Tumbleweed
    echo "Adding the Nvidia repository for Tumbleweed..."
    sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA

    # Ensuring the repository is trusted
    echo "Ensuring the repository is trusted..."
    sudo zypper --gpg-auto-import-keys ref

    # Installing the Nvidia drivers
    echo -e "Installing Nvidia drivers... ${RED}(Might be long)${RESET}"
    sudo zypper install -y nvidia_drivers_G06 nvidia_drivers_G06_kmp_default nvidia_gl_G06 nvidia_gl_G06_32bit nvidia_utils_G06 nvidia_video_G06 nvidia_video_G06_32bit

    echo "Nvidia drivers installed successfully."
}
