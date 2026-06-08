#!/bin/sh
# Resize root partition to fill available disk space on first boot.
# Runs once and disables itself.

set -e

ROOT_DEV=$(findmnt -n -o SOURCE /)
# e.g. /dev/mmcblk1p2 -> disk=/dev/mmcblk1, partnum=2
DISK=$(echo "$ROOT_DEV" | sed 's/p[0-9]*$//')
PARTNUM=$(echo "$ROOT_DEV" | grep -o '[0-9]*$')

echo "resize-rootfs: expanding $ROOT_DEV on $DISK (partition $PARTNUM)"

# Resize the partition table entry to fill the disk
echo ", +" | sfdisk --no-reread --force -N "$PARTNUM" "$DISK"

# Inform kernel about the new partition size without reboot
partx -u "$DISK" 2>/dev/null || true

# Online resize of the filesystem (ext4 supports online resize while mounted)
resize2fs "$ROOT_DEV"

echo "resize-rootfs: done"

# Disable this service so it never runs again
systemctl disable resize-rootfs.service
