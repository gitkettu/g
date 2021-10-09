#  
#  install_gentoo_chroot()
#  {
#    message "Inside chroot env"
    command env-update
#    command source /etc/profile
#    command export PS1="(chroot) $PS1"
#  
#    #Portage
#    message "Installing portage snapshot"
    command emerge-webrsync
#    message "Updating portage tree"
    command emerge --sync
  
    #Installation
#    message "Setting Profile to default/linux/amd64/13.0/desktop "
    command eselect profile set 1
#  
#    message "Updating @world set"
    command emerge --ask --update --deep --newuse @world
#  
#    message "Installing filesystem packages"
    command emerge vim
#  
#    message "Configuring timezone"
#    command echo "$TIMEZONE" > /etc/timezone
    command emerge --quiet --config sys-libs/timezone-data
#  
#    message "Writing /etc/locale.gen file"
#    cat << EOF > /etc/locale.gen
#  # All blank lines and lines starting with # are ignored.
#  #en_US ISO-8859-1
#   en_US.UTF-8 UTF-8
#  #ja_JP.EUC-JP EUC-JP
#  ja_JP.UTF-8 UTF-8
#  #ja_JP EUC-JP
#  #en_HK ISO-8859-1
#  #en_PH ISO-8859-1
#  #de_DE ISO-8859-1
#  #de_DE@euro ISO-8859-15
#  #es_MX ISO-8859-1
#  #fa_IR UTF-8
#  #fr_FR ISO-8859-1
#  #fr_FR@euro ISO-8859-15
#  #it_IT ISO-8859-1
#  EOF
#  
#  
    command locale-gen
#    command eselect locale set en_US.utf8
#  
#    message "Reloading Environment"
#    command env-update && source /etc/profile && export PS1="(chroot) $PS1"
#  
#    message "Downloading Kernel Sources"
    command emerge --ask sys-kernel/gentoo-sources
#  
#    message "Cleaning Kernel source folder"
    command cd /usr/src/linux/
    command make clean
#    
#    message "Loading kernel configuration file"
#    command mv -v /kernel-config /usr/src/linux/.config-gentoo-final
#    command cp -rv /usr/src/linux/.config-gentoo-final /usr/src/linux/.config
#  
#    message "Beginning Kernel Compilation Process"
    command make $MAKE_OPTIONS
    command make modules_install
    command make install
#  
#    message "Removing old kernel files"
#    command rm -rf /boot/*old
#    
#    message "Creating bootx64.efi, (Meant for UEFI systems)"
    command mkdir -pv /boot/efi/boot
    command cp /boot/vmlinuz-* /boot/efi/boot/bootx64.efi
#  
#    message "Installing genkernel"
    command emerge --ask sys-kernel/genkernel
#  
#    message "Generating initramfs"
#    command genkernel --${ROOT_FS_TYPE} --kerneldir=/usr/src/linux --kernel-config="/usr/src/linux/.config-gentoo-final" --install --no-ramdisk-modules initramfs
  # <fs>                  <mountpoint>    <type>          <opts>          <dump/pass>
  
#    message "Setting Hostname"
#    command sed -i "s/localhost/$HOSTNAME/g" /etc/conf.d/hostname
#    message "Creating /etc/conf.d/net"
#    command touch /etc/conf.d/net
#    message "Installing netifrc"
#    command emerge --ask --noreplace net-misc/netifrc
#    message "Setting network interfaces to activate at boot"
    command cd /etc/init.d
    command ln -s net.lo net.eth0
    command rc-update add net.eth0 default
#  
#    message "Installing tools, cronie, and mlocate for file indexing"
#    command emerge --ask $TOOLS
#  
#    message "Configuring Bootloader"
    echo GRUB_PLATFORMS="efi-64" >> /etc/portage/make.conf #For UEFI users only
    command emerge --ask sys-boot/grub:2
#    message "Installing grub2"
    command grub2-install --target=x86_64-efi --efi-directory=/boot
    command grub2-mkconfig -o /boot/grub/grub.cfg
#  
#    message "Base installation has finished but there are still some steps that have to be done"
#  }
#  
#  #exporting necessary functions and variables
#  export -f install_gentoo_chroot
#  export -f message
#  export -f command
#  
#  export LRED
#  export GREEN
#  export LCYAN
#  export LBLUE
#  export LPURPLE
#  export DGRAY
#  export NC
#  
#  export PACKAGES
#  export TIMEZONE
#  export CFLAGS
#  export CPU_FLAGS
#  export USE_FLAGS
#  export MAKE_OPTIONS
#  export BIOS_PARTITION
#  export BOOT_PARTITION
#  export SWAP_PARTITION
#  export ROOT_PARTITION
#  export ROOT_FS_TYPE
#  export MAKE_OPTIONS
#  export HOSTNAME
#  export TOOLS
#  
#  ./get-latest-stage3
#  install_gentoo_prep
