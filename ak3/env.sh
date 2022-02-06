if [ $(env | grep ANDROID_DATA | wc -c) -gt 0 ]; then
    export MAGISKBOOT="./tools/magiskboot"
    export MKDTIMG="./mkdtimg-aarch64"
    export DTC="./dtc-aarch64 -q"
else
    export MAGISKBOOT="./magiskboot-x86"
    export MKDTIMG="./mkdtimg-x86"
    export DTC="dtc -q"
fi