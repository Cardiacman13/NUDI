#!/usr/bin/env bash

# Fedora Nvidia Driver Installation Script
function fedora() {
    echo "|- Checking if use of BTRFS and if so, creating a simple snapshot to rollback if necessary."
    path="/"
    if [ "$(df -PT "$path" | awk 'NR==2 {print $2}')" = "btrfs" ] ; then
        mkdir -p /.snapshots/{root,home}
        echo "  |- Creating System BTRFS snapshot..."
        btrfs subvolume snapshot / /.snapshots/root/pre-nvidia > /dev/null 2>&1
        echo "  |- Creating Home BTRFS snapshot..."
        btrfs subvolume snapshot /home /.snapshots/home/pre-nvidia > /dev/null 2>&1
    fi

    echo "|- Enabling RPM Fusion and installing Nvidia drivers."

    echo "  |- Enabling RPM Fusion Free and Non-Free repositories..."
    # Enable RPM Fusion (Free and Non-Free)
    dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm > /dev/null 2>&1
    dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm > /dev/null 2>&1

    echo "  |- Setting exec stack..."
    # SELinux compatibility (source: https://doc.fedora-fr.org/wiki/Carte_graphique_NVIDIA_:_installation_des_pilotes_propri%C3%A9taires)
    setsebool -P allow_execstack on

    echo -e "  |- Installing Nvidia drivers... ${RED}(Might be long)${RESET}"
    # Install the Nvidia drivers
    dnf install -y akmod-nvidia > /dev/null 2>&1

    echo -e "  |- Forcing the build of kernel modules... ${RED}(Might be long)${RESET}"
    # Force the build of kernel modules
    akmods > /dev/null 2>&1

    echo -e "  |- Installing CUDA, 32-bit support and related packages... ${RED}(Might be long)${RESET}"
    # Optional: Install 32-bit support for 64-bit systems, useful for some games and applications
    dnf install -y vulkan > /dev/null 2>&1
    dnf install -y xorg-x11-drv-nvidia-libs.i686 > /dev/null 2>&1

    echo "|- Rebuilding initramfs..."

    echo -e "  |- Rebuilding initramfs... ${RED}(Might be long)${RESET}"
    dracut --force > /dev/null 2>&1

    echo "Nvidia drivers installed successfully."
}
