# Stretch-rescue-live custom

## ISO usage

### Disk less OS :
At the grub os selection screen pres `TAB` then append to the cmdline `toram` then press `ENTER`  
![GRUB_SCREEN](https://github.com/thomsh/stretch-rescue-live/blob/master/docs/screen_grub.png "Grub screen")

On boot completed and desktop (XFCE4) opened : you can remove the usb drive/iso

### Change keyboard
`setxkbmap us` or else

## Build instruction on Debian Stretch

Install the following packages :
 - `live-build`
 - `apt-cacher-ng`

Start the build :
`sudo ./make.sh`
