# Nvidia Universal Driver Installer (NUDI)

## Description

NUDI (Nvidia Universal Driver Installer) is a versatile Bash script designed to simplify the installation of Nvidia drivers across various Linux distributions. It supports Ubuntu, Debian, Fedora, Arch Linux, openSUSE, and their derivatives. This tool is especially useful for users seeking an easy and automated way to install Nvidia drivers without navigating through the intricacies of each distribution's package management and driver installation methods.

## Status: ALPHA

Please note that NUDI is currently in an ALPHA phase, which means it's under active development and might be subject to significant changes. While we strive to ensure stability and broad compatibility, please use this script with caution and at your own risk.

## Disclaimer

This script comes with no warranty or guarantee of functionality. It's important to backup your system and data before proceeding with the installation, especially since driver installation can significantly impact system stability and performance.

## Compatibility Note

NUDI is intended for use with Nvidia graphics cards that are compatible with the **latest Nvidia drivers**. If your Nvidia card is not compatible with the latest drivers, this script might not work for your setup. Always check your graphics card model and the Nvidia driver compatibility before using this script.

## Supported Distributions

- Ubuntu
- Debian
- Fedora
- Arch Linux
- openSUSE Leap
- openSUSE Tumbleweed

## Installation

To use NUDI, follow these steps:


   ```bash
   git clone https://github.com/Cardiacman13/NUDI.git
   cd NUDI
   chmod +x ./nvidiainstaller.sh
   sudo ./nvidiainstaller.sh
   ```


## Usage

Once you start the script, it will guide you through the process.

## Contributing

Contributions to NUDI are welcome! If you have suggestions, bug reports, or contributions, please open an issue or a pull request in the repository.
