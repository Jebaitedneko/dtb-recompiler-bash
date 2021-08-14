#!/bin/bash

# dtb recompiler
# TG: @mochi_wwww / GIT: Jebaitedneko

CURDIR=$(pwd)
DTC_BINARY="$CURDIR/dtc-aarch64"
ZIP_BINARY="$CURDIR/7zz-aarch64"
GRP_BINARY="$CURDIR/grep-aarch64"
chmod +x "$DTC_BINARY"
chmod +x "$ZIP_BINARY"
chmod +x "$GRP_BINARY"
dd if=/dev/block/bootdevice/by-name/boot of=boot.img

dtb_match_str="Qualcomm Technologies, Inc. SM8150 v2 SoC" # for Poco X3 Pro
dtb_offsets=$(LANG=C $GRP_BINARY -obUaPHn "\xd0\x0d\xfe\xed" boot.img | cut -f3 -d:)
i=1
while [ $i -lt 10 ]; do
	cur=$(echo $dtb_offsets | cut -f$i -d' ')
	i=$((i+1))
	nxt=$(echo $dtb_offsets | cut -f$i -d' ')
	i=$((i-1))
	siz=$((nxt-cur))
	if [[ $siz -gt 0 ]]; then
		echo -e "hdr=$cur\nsiz=$siz"
		dd if=boot.img of=$i.dtb skip=$cur count=$siz bs=1
		[[ "$($GRP_BINARY -q "$dtb_match_str" $i.dtb | cut -f1 -d:)" != "$i.dtb" ]] && break
	fi
	i=$((i+1))
done
$DTC_BINARY -I dtb -O dts -o dts $i.dtb &> /dev/null && rm $i.dtb

sed -i "s/soc {/soc: soc {/g" "dts"
sed -i "s/lmh-dcvs-00 {/lmh_0: lmh-dcvs-00 {/g" "dts"
sed -i "s/lmh-dcvs-01 {/lmh_1: lmh-dcvs-01 {/g" "dts"
cat "modifier.dtsi" >> "dts"
sed -i "s/==> dts <==//g" "dts"
$DTC_BINARY -I dts -O dtb "dts" -o "dtb" &> /dev/null && rm "dts"

cp dtb AK3-Template
(
	cd AK3-Template && $ZIP_BINARY a dtb-mod.zip * && mv *.zip ..
)
rm AK3-Template/dtb

cd "$CURDIR"
