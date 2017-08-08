#!/bin/bash
set -eux

lb clean
lb config
lb build

org_iso="live-image-amd64.hybrid.iso"
my_iso="stretch-rescue-live-$(date +%Y%m%d.%H%M).iso"

mv "$org_iso" "$my_iso"
ln -s "$my_iso" "$org_iso"
