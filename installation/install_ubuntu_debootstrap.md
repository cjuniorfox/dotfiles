Very basic instructions for how to install ubuntu throught using debootstrap from a docker image as source operating system. You need to have installed in your machine 'podman' and 'chroot' to do this installation.
Many was based on [this article](https://gist.github.com/subrezon/9c04d10635ebbfb737816c5196c8ca24)

# Mounting the partitions
I suppose you know how to partition your disk. You create the partition as you wish. In my case, I'm using my currently btrfs partition I have, creating only a new subvolume to do the installation. So I do as follows:

```
mount /dev/nvme0n1p3 /mnt
btrfs su cr /mnt/@ubnt
umount /mnt
```

Mount the target filesystem on mnt

```
mount /dev/nvme0n1p3 /mnt/ -o,subvol=@ubnt
```

Create the directories also to be mounted from other subvolumes and partitions

```
mkdir -p /mnt/{home,boot/efi}
```

Mount the paths. In my case, I'm just biding as I wish to use the same partitions I currently using for EFI and home

```
for i in /boot/efi/ /home/; do mount --bind $i /mnt$i; done
```

# Install the base system

Run podman containing the operating system image to be installed, mapping the target as the desired volume

```
podman run -it --privileged --rm -v /mnt/:/mnt/ docker.io/ubuntu:jammy /bin/bash
```

You should be into the podman container now. Let's prepare then:

```
apt update -y
apt install software-properties-common -y
add-apt-repository universe
apt update && apt upgrade -y
apt install debootstrap -y
```

The base installation

```
debootstrap jammy /mnt http://br.archive.ubuntu.com/ubuntu
```

This will take a while. After that, you can leave the podman container to mount the leftover directories and run the chroot to follow the installation procedure

```
exit
```
# Prepare the chroot environment
```
for i in /dev/ /dev/pts/ /run/ /proc/ /sys/ /sys/firmware/efi/efivars/; do mount --bind $i /mnt$i; done
```
Setup the fstab. In my case, I just copy the fstab from the current OS and change the things needed to change.
```
cp /etc/fstab /mnt/etc/fstab
vim /mnt/etc/fstab
```
Let's tweak some things, like removing packages that I don't want to be installed.
```
cat << HEREDOC > /mnt/etc/apt/preferences.d/ignored-packages
Package: snapd cloud-init landscape-common popularity-contest ubuntu-advantage-tools
Pin: release \*
Pin-Priority: -1
HEREDOC
```
Edit /mnt/etc/apt/sources.list, add -security and -updates suites, as well as restricted and universe repositories:
```
$ cat << HEREDOC > /mnt/etc/apt/sources.list
deb http://br.archive.ubuntu.com/ubuntu jammy           main restricted universe
deb http://br.archive.ubuntu.com/ubuntu jammy-security  main restricted universe
deb http://br.archive.ubuntu.com/ubuntu jammy-updates   main restricted universe
HEREDOC
```
# Setup your system
Now chroot the installation environment
```
chroot /mnt/
```
Lets configure the system
```
apt update && apt upgrade -y && \
  apt install -y --no-install-recommends \
    linux-{,image-,headers-}generic btrfs-progs \
    linux-firmware initramfs-tools efibootmgr
```
Set the machine's hostname
```
echo "zentac-ubnt" > /etc/hostname
echo "127.0.0.1 zentac-ubnt" >> /etc/hosts
```
# Setup users
Lock the root password (desirable)
```
passwd -l root
```
Add users:
```
useradd -mG sudo -s /bin/bash user
passwd user
```
# Setup the network
I prefer to using the NetworkManager instead of the 'netplan'. So do the following:
```
apt install network-manager
cat << HEREDOC > /etc/netplan/01-network-manager-all.yaml
#Let networkmanager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager
HEREDOC
systemctl enable NetworkManager
```
# Install other packages
Install useful packages on your system
```
apt install -y \
  at curl dmidecode ethtool firewalld fwupd gawk git gnupg htop man \
  needrestart openssh-server patch screen software-properties-common tmux zstd flatpak vim tldr bash-completion
```
Add Flatpak repository
```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
If you want to use Gnome Software, install the Gnome Software plugin for Flatpak

```
apt install gnome-software-plugin-flatpak
```
# Configure the localization settings
```
dpkg-reconfigure tzdata
dpkg-reconfigure locales
dpkg-reconfigure keyboard-configuration
```
# Install the Bootloader
```
apt install grub-efi-amd64 -y
grub-install /dev/nvme0n1
update-grub2
```
Set a short timeout:
```
echo 'GRUB_RECORDFAIL_TIMEOUT=5' >> /etc/default/grub.d/timeout-5sec.cfg
update-grub
```
# First boot
First, let's make take a snapshot for the installation in this stage.
If everything had been ok, you will be able to boot your machine into the newly installed operating system, but you will not have a graphical environment yet. 
```
mount /dev/nvme0n1p3 /mnt
btrfs su cr /mnt/snapshot
btrfs su sn / /mnt/snapshot/\@ubnt_$(date +"%Y-%m-%d_%H-%M")
```
To have the proper desktop working as intended, is needed to do some additional installation. In my case, I like to install the minimal graphical environment as possible and use the additional software from Flatpak. In this tutoral, I'll install the minimal Gnome.

The default Gnome terminal is the 'gnome-terminal' but I like the kitty insted.
```
apt install -y gnome-session kitty
```
Set the machine as 'graphical' environment
```
systemctl set-default graphical
```
# Nvidia drivers
You have two options for installing the NVidia drivers on your machine. By the own Ubuntu autoinstaller method or downloading the drivers from the NVidia.

## Automated install
It's just matter of instaling the 'ubuntu-drivers-common' and run the 'autoinstall'

```
apt install ubuntu-drivers-common
ubuntu-drivers autoinstall
```
## Downloading from NVidia's Official Website
This method isn't recommended because you need to follow a couple steps and run as 'multi-user' target, which turns the process way more counterintuitive, but anyway, let's go:
For further details, please follow [this link](https://linuxconfig.org/how-to-install-nvidia-driver-on-debian-12-bookworm-linux)

1. Download the drivers com [nvidia.com](https://www.nvidia.com.br/Download/index.aspx?)
2. Install the drivers prerequisites
```
apt -y install linux-headers-$(uname -r) build-essential libglvnd-dev pkg-config
```
3. Blacklist the Nouveau driver:
```
echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf
update-initramfs -u
```
4. Reboot as 'multi-user.target'
```
systemctl set-default multi-user.target
systemctl reboot
```
5. Login and install the driver
```
bash NVIDIA-Linux-x86_64-545.29.02.run
```
6. Install NVIDIA's 32-bit compatibility libraries and 'nvidia-xconfig' choosing 'Yes' while prompted.
7. Set the 'nvidia_drm' boot flag:
```
echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1"' > /etc/default/grub.d/nvidia-modeset.cfg
update-grub
```
7. Enable the GUI and reboot
```
systemctl set-default graphical.target
systemctl reboot
```

