if [ $(env | grep ANDROID_DATA | wc -c) -gt 0 ]; then
    export MAGISKBOOT="$(pwd)/tools/magiskboot"
    export MKDTIMG="$(pwd)/mkdtimg-aarch64"
    export DTC="$(pwd)/dtc-aarch64 -q"
else
    export MAGISKBOOT="$(pwd)/magiskboot-x86"
    export MKDTIMG="$(pwd)/mkdtimg-x86"
    export DTC="$(which dtc) -q"
fi