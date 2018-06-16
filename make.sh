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
## Put a timestamp in the generated ISO's filename.
##

org_iso="live-image-amd64.hybrid.iso"
version="$(date +%Y%m%d.%H%M)"
my_iso="${fn}-${version}.iso"
m4_name="${fn//-/_}_LATEST" ; m4_name="${m4_name^^}"
m4_file="${fn}.m4"

if [ -e "${org_iso}" ]; then
	echo "define(\`${m4_name}',\`${version}')dnl" > "${m4_file}"
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
