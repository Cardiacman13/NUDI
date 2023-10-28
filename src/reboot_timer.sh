#!/usr/bin/env bash

# Function for rebooting with a countdown timer
function reboot_timer() {
    local timer=$1

    echo -e "${GREEN}The script has completed, and the system needs to restart${RESET}: Press ${GREEN}Enter${RESET} to reboot or ${GREEN}Ctrl+C${RESET} to cancel."
    read -p "" choice
    if [[ "${choice}" == "" ]]; then
        while [[ ${timer} -gt 0 ]]; do
            echo -e "${GREEN}Restarting in ${timer} seconds...${RESET}"
            sleep 1
            ((timer--))
        done
    fi
    reboot
}
