#!/bin/bash
mount /dev/sdXY /mnt/gentoo
#mount /dev/sdXY /mnt/gentoo/boot

#cd /mnt/gentoo/

  command cp -L /etc/resolv.conf /mnt/gentoo/etc/

  command mount -t proc proc /mnt/gentoo/proc
  command mount --rbind /sys /mnt/gentoo/sys
  command mount --make-rslave /mnt/gentoo/sys
  command mount --rbind /dev /mnt/gentoo/dev
  command mount --make-rslave /mnt/gentoo/dev

  command chroot /mnt/gentoo /bin/bash
