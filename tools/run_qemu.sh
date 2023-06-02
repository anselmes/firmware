#!/bin/bash

set -e

: "${QEMU_EXEC:=qemu-system-riscv64}"

: "${BIOS:=./fw_dynamic.bin}"
: "${KERNEL:=./fw_qemu.elf}"

: "${BOOT_DRIVE:=./ubuntu-22.04.2-preinstalled-server-riscv64+unmatched.img}"
# : "${BOOT_DRIVE:=./starfive-jh7110-VF2-VF2_515_v2.3.0-55.img}"
# : "${BOOT_DRIVE:=./ubuntu-23.04-preinstalled-server-riscv64+visionfive2}"
# : "${BOOT_DRIVE:=./busybox-riscv64.img}"

"${QEMU_EXEC}" \
 -uuid $(uuidgen) \
 -accel tcg \
 -machine virt \
 -smp 4 \
 -m 8192 \
 -bios "${BIOS}" \
 -kernel "${KERNEL}" \
 -device virtio-rng \
 -device virtio-balloon \
 -device virtio-net-device,netdev=net0 \
 -netdev user,id=net0,hostname=qemu,hostfwd=tcp::1022-:22 \
 -device virtio-blk-device,drive=hd0 \
 -drive id=hd0,if=none,format=raw,file="${BOOT_DRIVE}" \
 -serial mon:stdio \
 -nographic \
 $@
