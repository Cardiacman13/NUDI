#!/usr/bin/env bash

# Set the script to exit on error
set -e

# ====================================== Color Definitions ======================================

# Color definitions
GREEN=$(tput setaf 2)  # Green
PURPLE=$(tput setaf 5) # Purple
RED=$(tput setaf 1)    # Red
RESET=$(tput sgr0)     # Reset

# ============================================= Sudo Checks ==============================================

# Check for root privileges
if sudo -v; then
    echo -e "${GREEN}Authentication successful.${RESET}"
else
    echo -e "${RED}Authentication failed. The script requires root privileges to run.${RESET}"
    exit 1
fi

# =========================================== Imports ===========================================

# Import configuration scripts
source src/ubuntu.sh
source src/debian.sh
source src/archlinux.sh
source src/fedora.sh
source src/opensuse.sh
source src/opensusetw.sh
source src/reboot_timer.sh
source src/utils.sh

# ============================================= Welcome Message Function =============================================

# Function to display the welcome message
function welcome_msg() {
    clear
    echo -e "${GREEN}Welcome to the Nvidia installation script!${RESET}"
    echo -e "-----------------------------------------------------------------------------------------------------------

       ${PURPLE}%%%%%%%%%%${RESET}  ${GREEN}*********${RESET}
       ${PURPLE}%%%${RESET}                 ${GREEN}******${RESET}
       ${PURPLE}%%%${RESET}                     ${GREEN}***${RESET}
       ${PURPLE}%%%${RESET}                     ${GREEN}***${RESET}
       ${PURPLE}%%%${RESET}                     ${GREEN}***${RESET}      GitHub: https://github.com/Cardiacman13
       ${PURPLE}%%%${RESET}                     ${GREEN}***${RESET}
       ${PURPLE}%%%${RESET}                     ${GREEN}***${RESET}
        ${PURPLE}%%%%%%${RESET}                 ${GREEN}***${RESET}
             ${PURPLE}%%%%%%%%${RESET}  ${GREEN}***********${RESET}

-----------------------------------------------------------------------------------------------------------\n"
    sleep 1
    echo -e "${RED}This script will make changes to your system.${RESET}"
    echo -e "Some steps may take time depending on your internet connection and CPU.\nPress ${GREEN}Enter${RESET} to continue or ${GREEN}Ctrl+C${RESET} to cancel."
    read -p "" choice
    if [[ $choice != "" ]]; then
        exit 0
    fi
}

# =========================================== Distribution Choice ===========================================

# Asking the user to choose their distribution
function choose_distro() {
    echo -e "Please choose your distribution:
    1) Ubuntu
    2) Debian
    3) Fedora
    4) Arch Linux
    5) openSUSE Leap
    6) openSUSE Tumbleweed"
    read -p "Enter the number of your choice: " distro_choice

    case $distro_choice in
        1)
            ubuntu
            ;;
        2)
            debian
            ;;
        3)
            fedora
            ;;
        4)
            archlinux
            ;;
        5)
            opensuse
            ;;
        6)
            opensuse_tw
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${RESET}"
            choose_distro
            ;;
    esac
}

# ============================================ Main Function ============================================

# Main function
function main() {
    local start_time
    start_time=$(date +%s)

    welcome_msg
    choose_distro  # Let the user choose their distribution

    local end_time
    end_time=$(date +%s)
    local duration
    duration=$((end_time - start_time))

    # Display the script execution duration
    echo -e "${GREEN}The script took ${duration} seconds to execute.${RESET}"
    reboot_timer 10
}

main
