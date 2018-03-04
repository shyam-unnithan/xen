#!/bin/sh
#Automation of installation of Xen Hypervisor

#Install non-free firmware
apt-get -y install firmware-linux-nonfree

#Install Large Volume Management
apt-get -y install lvm2

#Create the allocated LVM as a Physical Volume. Change sda4 to whichever
#device you had created as LVM for installation
pvcreate /dev/sda4

#Create a Volume Group (extents) using physical Volume
#Replace sda4 with device mentioned in pvcreate
vgcreate vg0 /dev/sda4

#Install bridge utils for network bridging
apt-get -y install bridge-utils

#Configure bridging interface
echo "" >> /etc/network/interfaces
echo "#The bridge network interface" >> /etc/network/interfaces
echo "auto xenbr0" >> /etc/network/interfaces && echo "iface xenbr0 inet dhcp" >> /etc/network/interfaces
# Change the iface name enp3s0 as applicable e.g. eth0
echo -e "\t bridge_ports enp3s0" >> /etc/network/interfaces

#Restart the network service
service networking restart

#Install Xen Server
apt-get -y install xen-hypervisor-4.8-amd64 xen-tools xen-utils-4.8

#Create a lv disk to be used with our vm
lvcreate -ndisk_0 -L20G vg0

#Ensure that you create a small boot partition as the first partition on the LVM
#The size of the partition has to be small or you end up installing the Server
#and eventually it will refuse to install GRUB2 since the size of core.img
#is greater than that the MBR can accomodate. This is a classic problem with LVM

#You will be able to see the installation screen when you connect to the
#ip address of the installation on port 5900 using vnc viewer.

#Also ensure that on first boot of the guest VM you will have to edit the
#/etc/network/interfaces file and update the information regarding the eth0
#interace. Add following lines withou the comment marks
# auto eth0
#iface eth0 inet dhcp
#This will ensure that your guest vm is able to connect to the network get an IP and
#hosts will be able to connect to this guest based ont he guests IP address.
