# dtb-recompiler-bash
dtb patcher for aarch64

prerequisites: zip dtc

steps in tmux

allow storage permissions for tmux

`git clone --depth=1 https://github.com/Jebaitedneko/dtb-recompiler-bash drc`

`cd drc`

only once (to get boot.img):

`pkg install zip dtc python`

`su`

`sh img.sh`

`exit`

always:

edit mod.dtsi as needed

`./run.sh`

to recompile

flashable dtb-mod.zip will be generated in drc
