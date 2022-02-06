[ ! -f boot.img ] && dd if=/dev/block/bootdevice/by-name/boot of=boot.img
[ ! -f dtbo-stock.img ] && dd if=/dev/block/bootdevice/by-name/dtbo of=dtbo-stock.img