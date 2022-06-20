#/usr/bin/env bash

set -e -u

BOOT_DIR="/boot"
BOOT_MOUNTS=$(cat /proc/mounts | grep "$BOOT_DIR" | cut -d ' ' -f 2)
distribute() {
	SOURCE="$1"
	if [ -f "$SOURCE" ]; then
		for MOUNT in $BOOT_MOUNTS; do
			cp -a "$SOURCE" "$MOUNT"
		done
		rm "$SOURCE"
	fi
}

KERNEL=$(pacman -Qq | grep '^linux$\|^linux-lts$')
distribute "$BOOT_DIR/vmlinuz-$KERNEL"
distribute "$BOOT_DIR/initramfs-$KERNEL.img"

MICROCODE=$(pacman -Qq | grep 'ucode$')
distribute "$BOOT_DIR/$MICROCODE.img"
