#!/bin/bash

# dtb recompiler
# TG: @mochi_wwww / GIT: Jebaitedneko

[[ ! -f dtbo-stock.img ]] && echo -e "Run\n\n\nsu\n\nsh img.sh\n\nexit\n\n\nand then re-run run-dtbo.sh" && exit
chmod +x dtb.py && python dtb.py dtbo-stock.img &> /dev/null && mv dtb dtbs
mv "$(grep "VAYU" dtbs/*.dtb -l)" "./dtb" && rm -rf dtbs
dtc -I dtb -O dts -o dts dtb &> /dev/null && rm dtb
cp dts dts.old

function label() {
	sed -i "s/$1 {/$2: $1 {/g" "dts"
}

echo -e "\n" >> dts

function get_frag_num() {
	FRAG_NUM=$(grep -B4 $1 dts | tail -n5 | head -n1 | grep -oE '[0-9]+')
}

TEMPLATE="
__local_fixups__ {
	fragment@FRAG_NUM {
		__overlay__ {
			NODE_NAME {
				PROP;
			};
		};
	};
};
"

function push_node() {
	get_frag_num $1
	FIXUP=$(echo $TEMPLATE | sed "s/FRAG_NUM/$FRAG_NUM/g;s/NODE_NAME/$1/g;s/PROP/$(echo -e $2)/g")
	echo -e "/ { $FIXUP };" >> dts
}

push_node "qcom,mdss_dsi_j20s_36_02_0a_dsc_video" '
	qcom,esd-check-enabled;
	qcom,mdss-dsi-panel-status-check-mode = "reg_read";
	qcom,mdss-dsi-panel-status-command = [06 01 00 01 00 00 01 0a];
	qcom,mdss-dsi-panel-status-command-state = "dsi_lp_mode";
	qcom,mdss-dsi-panel-status-value = <0x9c>;
	qcom,mdss-dsi-panel-status-read-length = <1>;
'

push_node "qcom,mdss_dsi_j20s_42_02_0b_dsc_video" '
	qcom,esd-check-enabled;
	qcom,mdss-dsi-panel-status-check-mode = "reg_read";
	qcom,mdss-dsi-panel-status-command = [06 01 00 01 00 00 01 0a];
	qcom,mdss-dsi-panel-status-command-state = "dsi_lp_mode";
	qcom,mdss-dsi-panel-status-value = <0x9c>;
	qcom,mdss-dsi-panel-status-read-length = <1>;
'

sed -i "s/;;/;/g" "dts"
dtc -I dts -O dtb -o "dtb" "dts" &> /dev/null
dtc -I dtb -O dts -o "dts.new" "dtb" &> /dev/null
if grep -Fxq avbtool dtbo-stock.img; then
	echo
else
	echo "Your dtbo has AVB enabled."
	echo "It is preferred to do the following via fastboot:"
	echo "fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img"
	echo "then"
	echo "fastboot --disable-verity --disable-verification flash vbmeta_system vbmeta_system.img"
	echo "where vbmeta.img and vbmeta_system.img are blank vbmeta (provided below)"
	echo "https://github.com/Jebaitedneko/dtb-recompiler-bash#disabled-vbmetas"
	echo "Afterwards, you can flash the dtbo-mod.zip as normal."
fi
echo "Done."
echo -e "\nAutogenerated from dtbo-recompiler\nby MOCHI [TG: @mochi_wwww | GIT: @Jebaitedneko]\n" > ak3/banner
echo -e "$(diff -ur dts.old dts.new)" >> ak3/banner && rm dts.old dts.new dts
chmod +x mkdtboimg.py && python mkdtboimg.py create dtbo.img --page_size=4096 dtb && rm dtb
[[ -f dtbo-mod.zip ]] && rm dtbo-mod.zip
mv dtbo.img ak3 && ( cd ak3 && zip -r9 ../dtbo-mod.zip ./* &> /dev/null ) && rm ak3/dtbo.img ak3/banner
[[ -d /sdcard ]] && mv *.zip /sdcard