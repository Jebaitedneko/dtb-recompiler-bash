# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers
properties() { '
kernel.string=generic
device.name1=generic
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
'; }
block=/dev/block/bootdevice/by-name/boot;
# For AB
# is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;
. tools/ak3-core.sh;
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
dump_boot;
if [ -d $ramdisk/overlay ]; then
rm -rf $ramdisk/overlay;
fi;
write_boot;
# For vendor_boot
# block=vendor_boot;
# reset_ak;
# split_boot;
# flash_boot;