IMAGE="$1"
MATCH="$2"
[ -d dtbs ] && rm -rf dtbs; mkdir dtbs || mkdir dtbs
if [ $IMAGE == 'boot.img' ]; then
    $MAGISKBOOT unpack "$IMAGE" &> /dev/null && mv dtb dtb.pack && rm kernel ramdisk.cpio
    xxd -g0 dtb.pack | cut -f2 -d' ' | cut -f1 -d ' ' | tr -d '\n' | sed -E 's/(d00dfeed)/\n\1/g' > dtb.pack.xxd
    sed -i '1d' dtb.pack.xxd
    grep d00dfeed dtb.pack.xxd | while read f; do i=$((i+1)); xxd -r -p <(echo "$f") > dtbs/$i.dtb; done
    rm -rf dtb.pack dtb.pack.xxd
else
    $MKDTIMG dump "$IMAGE" -b dtbos &> /dev/null
    [ -f dtbos.0 ] && mv dtbos* dtbs
fi

( cd dtbs; ls -1 * | while read f; do dtc -q -I dtb -O dts "$f" -o $(echo "$f" | sed -E "s/.dtb//g;s/dtbos.([0-9]+)/\1/g").dts; done; rm *dtb* )
mv "$(grep -r "$MATCH" -l dtbs)" "./dts" && rm -rf dtbs