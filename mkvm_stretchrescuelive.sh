#!/bin/bash
set -eu

# Hint:
# Add --print-xml --dry-run to the command line to generate the
# VM's XML definition without actually creating the VM.

n=$(basename "$0")
n=${n#mkvm_}
n=${n%.sh}
n=${n,,}

ntst=$(echo "$n" | sed 's/^[a-z0-9][a-z0-9-]*[a-z0-9]$//')
if [ -n "$ntst" ]; then
	echo "$n is not an acceptable VM name."
	exit 1
fi

vmname="$n"

virt-install \
	--noautoconsole \
	--virt-type	"kvm" \
	--connect	"${LIBVIRT_DEFAULT_URI:-qemu:///system}" \
	--name		"$vmname" \
	--memory	2048 \
	--vcpus		2 \
	--disk		"pool=vg0,size=20" \
	--network	"bridge=br0" \
	--graphics	"vnc,listen=0.0.0.0" \
	--os-variant	"debiantesting" \
	--cdrom		"$HOME/stretch-rescue-live/live-image-amd64.hybrid.iso" \
	--livecd \
	"${@}"
