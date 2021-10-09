install_gentoo_chroot()
{
  # "Inside chroot env"
  command env-update
  command source /etc/profile
  command export PS1="(chroot) $PS1"

  #Portage
  # "Installing portage snapshot"
  command emerge-webrsync
  # "Updating portage tree"
  command emerge --sync

  # "Configuring /etc/portage/make.conf"
  cat << EOF > /etc/portage/make.conf

CFLAGS="-march=native -O2 -pipe"
CXXFLAGS="${CFLAGS}"
CPU_FLAGS="${CFLAGS}"

# WARNING: Changing your CHOST is not something that should be done lightly.
# Please consult http://www.gentoo.org/doc/en/change-chost.xml before changing.
CHOST="x86_64-pc-linux-gnu"
# These are the USE flags that were used in addition to what is provided by the
# profile used for building.

USE="X savedconfig xinerama elogind suid"
MAKEOPTS="-j3"
VIDEO_CARDS="radeon"
INPUT_DEVICES="libinput synaptics"

ACCEPT_LICENSE="*"
EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --autounmask=n"

PORTDIR="/var/db/repos/gentoo"
DISTDIR="/var/cache/distfiles"
PKGDIR="/var/cache/packages"

GRUB_PLATFORMS="pc"

EOF

  #Installation
  # "Setting Profile to 1 "
  command eselect profile list
  command eselect profile set 1

  # "Updating @world set"
  command emerge --ask --update --deep --newuse @world

  # "Installing filesystem packages"
  command emerge --ask $PACKAGES

  # "Configuring timezone"
  command echo "$TIMEZONE" > /etc/timezone
  command emerge --quiet --config sys-libs/timezone-data

  # "Writing /etc/locale.gen file"
  cat << EOF > /etc/locale.gen
# All blank lines and lines starting with # are ignored.
#en_US ISO-8859-1
 en_US.UTF-8 UTF-8
#ja_JP.EUC-JP EUC-JP
ja_JP.UTF-8 UTF-8
#ja_JP EUC-JP
#en_HK ISO-8859-1
#en_PH ISO-8859-1
#de_DE ISO-8859-1
#de_DE@euro ISO-8859-15
#es_MX ISO-8859-1
#fa_IR UTF-8
#fr_FR ISO-8859-1
#fr_FR@euro ISO-8859-15
#it_IT ISO-8859-1
EOF


  command locale-gen
  command eselect locale set en_US.utf8

  # "Reloading Environment"
  command env-update && source /etc/profile && export PS1="(chroot) $PS1"

  # "Downloading Kernel Sources"
  command emerge --ask sys-kernel/gentoo-sources

  # "Cleaning Kernel source folder"
  command cd /usr/src/linux/
  command make clean
  command make mrproper

  # "Beginning Kernel Compilation Process"
  command make 
  command make modules_install
  command make install

  # "Installing genkernel"
  command emerge --ask sys-kernel/genkernel

  cat << EOF > /etc/fstab
# /etc/fstab: static file system information.
#
# noatime turns off atimes for increased performance (atimes normally aren't
# needed); notail increases performance of ReiserFS (at the expense of storage
# efficiency).  It's safe to drop the noatime options if you want and to
# switch between notail / tail freely.
#
# The root filesystem should have a pass number of either 0 or 1.
# All other filesystems should have a pass number of 0 or greater than 1.
#
# See the manpage fstab(5) for more information.
#

# <fs>                  <mountpoint>    <type>          <opts>          <dump/pass>

# NOTE: If your BOOT partition is ReiserFS, add the notail option to opts.
${BOOT_PARTITION}               /boot           vfat            noauto,noatime  1 2
${SWAP_PARTITION}               none            swap            sw              0 0
${ROOT_PARTITION}               /               ext4           noatime         	0 1
EOF

  # "Setting Hostname"
  command sed -i "s/localhost/$HOSTNAME/g" /etc/conf.d/hostname
  # "Creating /etc/conf.d/net"
  command touch /etc/conf.d/net
  # "Installing netifrc"
  command emerge --ask --noreplace net-misc/netifrc
  # "Setting network interfaces to activate at boot"
  command cd /etc/init.d
  command ln -s net.lo net.enp1s0
  command rc-update add net.enp1s0 default

  # "Configuring Bootloader"
  echo GRUB_PLATFORMS="pc" >> /etc/portage/make.conf #For BIOS
  command emerge --ask sys-boot/grub
  # "Installing GRUB"
  command grub-install /dev/sda
  command grub-mkconfig -o /boot/grub/grub.cfg
  # "Base installation has finished but there are still some steps that have to be done manual. GRUB install plz"
}

#exporting necessary functions and variables
export -f install_gentoo_chroot
export -f #
export -f command

export LRED
export GREEN
export LCYAN
export LBLUE
export LPURPLE
export DGRAY
export NC

export PACKAGES
export TIMEZONE
export CFLAGS
export CPU_FLAGS
export USE_FLAGS
export MAKE_OPTIONS
#export BIOS_PARTITION
export BOOT_PARTITION
export SWAP_PARTITION
export ROOT_PARTITION
export ROOT_FS_TYPE
export MAKE_OPTIONS
export HOSTNAME
export TOOLS

#./get-latest-stage3
install_gentoo_chroot
