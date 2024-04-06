#!/bin/bash
set -e

# BASE INSTALL
sudo pacman -S --noconfirm --needed base-devel
sudo pacman -S --noconfirm --needed vim

# BASE XORG
sudo pacman -S --noconfirm --needed xorg-server
sudo pacman -S --noconfirm --needed xorg-xinit
sudo pacman -S --noconfirm --needed xorg-xsetroot
sudo pacman -S --noconfirm --needed libx11
sudo pacman -S --noconfirm --needed libxinerama
sudo pacman -S --noconfirm --needed libxft
sudo pacman -S --noconfirm --needed webkit2gtk
sudo pacman -S --noconfirm --needed xdg-desktop-portal
sudo pacman -S --noconfirm --needed xdg-desktop-portal-lxqt
sudo pacman -S --noconfirm --needed xdg-desktop-portal-gtk

# CPU SETUP SCRIPT
numberofcores=$(grep -c ^processor /proc/cpuinfo)

if [ $numberofcores -gt 1 ]
then
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores+1))'"/g' /etc/makepkg.conf;
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
else
        echo "No change."
fi

# KERNEL HEADERS
sudo pacman -S --noconfirm --needed linux-zen-headers

# BLUETOOTH
sudo pacman -S --noconfirm --needed bluez
sudo pacman -S --noconfirm --needed bluez-libs
sudo pacman -S --noconfirm --needed bluez-utils
sudo pacman -S --noconfirm --needed blueman

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

# PRINTER
#sudo pacman -S --noconfirm --needed cups cups-pdf

#first try if you can print without foomatic
#sudo pacman -S foomatic-db-engine --noconfirm --needed
#sudo pacman -S foomatic-db foomatic-db-ppds foomatic-db-nonfree-ppds foomatic-db-gutenprint-ppds --noconfirm --needed
#sudo pacman -S ghostscript gsfonts gutenprint --noconfirm --needed
#sudo pacman -S gtk3-print-backends --noconfirm --needed
#sudo pacman -S libcups --noconfirm --needed
#sudo pacman -S hplip --noconfirm --needed
#sudo pacman -S system-config-printer --noconfirm --needed

#sudo systemctl enable org.cups.cupsd.service

#echo "After rebooting it will work"

#echo "################################################################"
#echo "#########   printer management software installed     ##########"
#echo "################################################################"

# BASE PROGRAMS
sudo pacman -S --noconfirm --needed firefox
sudo pacman -S --noconfirm --needed neofetch
sudo pacman -S --noconfirm --needed gnome-disk-utility
sudo pacman -S --noconfirm --needed pcmanfm
sudo pacman -S --noconfirm --needed xarchiver
sudo pacman -S --noconfirm --needed picom
sudo mkdir /home/$USER/.config/picom
sudo cp picom.conf /home/$USER/.config/picom
sudo pacman -S --noconfirm --needed lxappearance
sudo pacman -S --noconfirm --needed mesa-utils
sudo pacman -S --noconfirm --needed lib32-mesa-utils
sudo pacman -S --noconfirm --needed ntfs-3g
sudo pacman -S --noconfirm --needed os-prober
sudo pacman -S --noconfirm --needed pavucontrol
sudo pacman -S --noconfirm --needed wget
sudo pacman -S --noconfirm --needed usb_modeswitch
sudo pacman -S --noconfirm --needed wine
sudo pacman -S --noconfirm --needed winetricks
sudo pacman -S --noconfirm --needed gparted
sudo pacman -S --noconfirm --needed feh
sudo pacman -S --noconfirm --needed conky
sudo mkdir /home/$USER/.config/conky
sudo cp conky.conf /home/$USER/.config/conky
sudo pacman -S --noconfirm --needed lm_sensors
sudo pacman -S --noconfirm --needed hddtemp
sudo pacman -S --noconfirm --needed curl
sudo pacman -S --noconfirm --needed xdg-user-dirs
xdg-user-dirs-update
sudo pacman -S --noconfirm --needed qbittorrent
sudo pacman -S --noconfirm --needed alacritty
sudo pacman -S --noconfirm --needed lutris
sudo pacman -S --noconfirm --needed flameshot
sudo pacman -S --noconfirm --needed vlc
sudo pacman -S --noconfirm --needed galculator
sudo pacman -S --noconfirm --needed ristretto
sudo pacman -S --noconfirm --needed mangohud lib32-mangohud
sudo pacman -S --noconfirm --needed gamemode lib32-gamemode
sudo pacman -S --noconfirm --needed gvfs
sudo pacman -S --noconfirm --needed volumeicon
sudo pacman -S --noconfirm --needed nm-connection-editor
sudo pacman -S --noconfirm --needed network-manager-applet
sudo systemctl restart NetworkManager.service

# FONTS
sudo pacman -S adobe-source-sans-pro-fonts --noconfirm --needed
sudo pacman -S cantarell-fonts --noconfirm --needed
sudo pacman -S noto-fonts --noconfirm --needed
sudo pacman -S ttf-bitstream-vera --noconfirm --needed
sudo pacman -S ttf-dejavu --noconfirm --needed
sudo pacman -S ttf-droid --noconfirm --needed
sudo pacman -S ttf-hack --noconfirm --needed
sudo pacman -S ttf-inconsolata --noconfirm --needed
sudo pacman -S ttf-liberation --noconfirm --needed
sudo pacman -S ttf-roboto --noconfirm --needed
sudo pacman -S ttf-ubuntu-font-family --noconfirm --needed
sudo pacman -S noto-fonts-emoji --noconfirm --needed
sudo pacman -S ttf-font-awesome --noconfirm --needed

# AMD UCODE
sudo pacman -S amd-ucode --noconfirm
sudo grub-mkconfig -o /boot/grub/grub.cfg

# NVIDIA
sudo pacman -S --noconfirm --needed nvidia-dkms nvidia-utils nvidia-settings

# NVIDIA 32 bit libs + LIBS for STEAM
sudo pacman -S --noconfirm --needed lib32-libvdpau
sudo pacman -S --noconfirm --needed lib32-libva
sudo pacman -S --noconfirm --needed lib32-nvidia-utils
sudo pacman -S --noconfirm --needed lib32-libxtst
sudo pacman -S --noconfirm --needed lib32-libxrandr
sudo pacman -S --noconfirm --needed lib32-libpulse
sudo pacman -S --noconfirm --needed lib32-gdk-pixbuf2
sudo pacman -S --noconfirm --needed lib32-gtk2
sudo pacman -S --noconfirm --needed lib32-openal

# NOUVEAU DRIVER DISABLE
sudo cp blacklist-nouveau.conf /etc/modprobe.d/
sudo cp nouveau-kms.conf /etc/modprobe.d/

# STEAM
sudo pacman -S --noconfirm --needed steam
sudo chmod +x update-proton-ge
./update-proton-ge

# STEAM DOWNLOAD FIX
sudo cp steam_dev.cfg /.local/share/Steam/

# XORG SETUP
sudo cp -a xorg.conf.d /etc/X11/

# AUTORUN
cp .xinitrc /home/$USER/
cp .bash_profile /home/$USER/

# WALLPAPER
cp wallpaper.jpg /home/$USER/Pictures/
