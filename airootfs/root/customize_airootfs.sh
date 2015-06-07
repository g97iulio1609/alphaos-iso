#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
groupadd autologin
useradd -m -g users -G "audio,disk,optical,wheel,network,autologin" alpha
usermod -s /usr/bin/zsh alpha
cp -aT /etc/skel/ /root/
chmod 700 /root
chown root:root /etc/sudoers 
chmod 440 /etc/sudoers
chown -R root:root /etc/sudoers.d
chmod  755 /etc/sudoers.d 
chmod  440 /etc/sudoers.d/*
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf
systemctl enable  lightdm.service org.cups.cupsd.service NetworkManager.service pacman-init.service choose-mirror.service
systemctl --user enable pulseaudio.socket
systemctl set-default multi-user.target
systemctl set-default graphical.target

