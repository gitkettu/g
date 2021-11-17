#!/bin/bash
exec qemu-system-x86_64 -enable-kvm \
        -cpu host \
        -drive file=Gentoo-VM.img,if=virtio \
        -netdev user,id=vmnic,hostname=Gentoo-VM \
        -device virtio-net,netdev=vmnic \
        -device virtio-rng-pci \
        -m 512M \
        -smp 2 \
        -monitor stdio \
        -name "Gentoo VM" \
        $@
