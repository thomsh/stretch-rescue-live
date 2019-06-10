# Stretch-rescue-live custom

## ISO usage: How to eject USB after boot ?
Disk less distro, using `toram` arg.  
On boot completed and desktop (XFCE4) opened : you can remove the usb drive/iso  
Ram Usage (2019-06-10 build) :  
With `toram` : 1.48GB  
Without (default boot) : ~270MB  

### ON non-UEFI boot
At the grub os selection screen pres `TAB` then append to the cmdline `toram` then press `ENTER`  
![GRUB_SCREEN](https://github.com/thomsh/stretch-rescue-live/blob/master/docs/screen_grub.png "Grub screen")

### On UEFI boot
Press `e` to edit grub `Live system` and append `toram` arg at the end of the `linux` line.
Press CTRL + X to boot or F10


## Change keyboard layout
On a GIU terminal :`setxkbmap us` to switch on `us` keyboard  
On a TTY : `loadkeys us`

# Build instruction on Debian Stretch

## Install the following packages
`apt-get install -y live-build apt-cacher-ng`

## Start the build :
`sudo ./make.sh`  

### cleanup
cleanup your build folder, this will remove iso file too.
`./clean.sh`
