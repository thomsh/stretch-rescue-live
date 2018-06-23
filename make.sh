#!/bin/bash
set -eu

fn="stretch-rescue-live"

##
## Ensure the working directory contains me.
##

me=$(readlink -e "$0")
wd=$(dirname "${me}")
wb=$(basename "${me}")
cd "${wd}"

##
## Check that I'm running as root
##

if [ $(id -u) -ne 0 ]; then

	echo
	echo "${wb} must be run as root (or with sudo)."
	echo
	exit 1
fi

##
## Clean up ISOs from previous build run.
##

rm -f *.iso

##
## Load the desired ssh pub-keys into the live chroot.
##

tmpfile="$(mktemp)"

find authorized_keys.d -iname '*.pub' -print | sort |
while read pk ; do
	cat "${pk}" >> "${tmpfile}"
	echo "Added pubkey '${pk}'"
done

if [ -s "${tmpfile}" ]; then

	root_home="config/includes.chroot/root"

	mkdir -p "${root_home}/.ssh/"
	cp "${tmpfile}" "${root_home}/.ssh/authorized_keys"
	chmod -R u+rwX,go-rwx "${root_home}"
fi

rm -f "${tmpfile}"

##
## Run the debian live build process.
##

set -x

lb clean
lb config
lb build

set +x

##
## Function definitions
##

generate_m4_macro() {
	local f="$1"
	local v="$2"
	local m="${f//-/_}_LATEST"
	m="${m^^}"
	echo "define(\`${m}',\`${v}')dnl"
}

col2_pad_len() {
	local colstr="$1"
	local maxcol="stretch-rescue-live"
	local maxlen=${#maxcol}
	local padlen=$[ $maxlen - ${#colstr} ]
	if [ $padlen -ge 0 ]; then
		echo $padlen
	else
		echo 0
	fi
}

generate_grub_menuentry() {
	local f="$1"
	local v="$2"
	printf "menuentry ' Debian Live amd64 :: ${f}%*s :: ${v} ' {\n" $(col2_pad_len "${f}")
	cat <<EOF
	iso_path="/boot/isos/${f}-${v}.iso"
	export iso_path
	kernelopts=" live-media=removable-usb "
	export kernelopts
	loopback loop "\$iso_path"
	set root=(loop)
	configfile "/boot/grub/loopback.cfg"
}
EOF
}

##
## Put a version (timestamp) in the generated ISO's filename.
##

org_iso="live-image-amd64.hybrid.iso"
version="$(date +%Y%m%d.%H%M)"
my_iso="${fn}-${version}.iso"

##
## Generate some useful artifacts related to the new ISO:
## - an m4 macro containing the version string (timestamp)
## - a snippet of grub config that can boot the ISO from a loopback mount
##

m4_file="${fn}.m4"
grub_file="${fn}_grub-loop-boot.cfg"

if [ -e "${org_iso}" ]; then
	generate_m4_macro "${fn}" "${version}" > "${m4_file}"
	generate_grub_menuentry "${fn}" "${version}" > "${grub_file}"
	mv "$org_iso" "$my_iso"
	ln -s "$my_iso" "$org_iso"
	echo
	echo "Generated '$my_iso'"
	echo
	exit 0
else
	echo
	echo "Failed to create the Debian Live ISO."
	echo
	exit 1
fi

exit 0
