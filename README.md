# devicetree patcher for embedded devices (dtb and dtbo supported)
## 1. Install required packages for tmux
```
pkg install git zip dtc python
```
## 2. Allow storage permissions for tmux

## 3. Clone this repo
```
git clone --depth=1 https://github.com/Jebaitedneko/dtb-recompiler-bash drc
cd drc
```
## 4. Get boot.img and dtbo.img (saved as dtbo-stock.img) [to be done just once]
```
su
sh img.sh
exit
```
## 5. Modifications and recompiling

## DTB Modding

Edit mod.dtsi as needed, then recompile with

`./run-dtb.sh`

A flashable dtb-mod.zip will be pushed to /sdcard.

## DTBO Modding

Modding done via `push_node` function call

```
push_node "node_name" '
prop-0;
prop-1 = <val>;
prop-2 = [f0 0f];
prop-3 - "str"
'

```

node_name must exist within the dtbo, as we are applying a local fixup to node_name.


Otherwise, use dtb modder if the node is defined there.


DTBO Mod method is there primarily for nodes which are absent in the base dtb.


Things like sde panels work this way as they were abstracted out from the base dtb for decluttering


It is to be noted that the second agument be passed within single quotes.
Manually escape any double quotes in the properties if you are planning to use double quotes anyways.

Edit `run-dtbo.sh` and add new `push_node` function calls as needed, then recompile with

`./run-dtbo.sh`

A flashable dtbo-mod.zip will be pushed to /sdcard.

### Notes for those who want to adapt this for their devices

#### 1. Edit DT match string [DTB/DTBO]

#### [DTB]
Edit [this string](https://github.com/Jebaitedneko/dtb-recompiler-bash/blob/master/run-dtb.sh#L9) to what your device uses.

#### [DTBO]
Edit [this string](https://github.com/Jebaitedneko/dtb-recompiler-bash/blob/master/run-dtbo.sh#L8) to what your device uses.

This can be found out easily by grabbing a DMESG from a normal boot cycle and search for any line with `(DT)` or `MACHINE`.

You should see a similar string. That is the name of the dtb that the kernel uses to identify the hardware layout and configurations of your device.

#### 2. update label arguments [DTB]

The `label` function defined in `run-dtb.sh` takes an existing node name as the first argument and labels it with the label you provide as second argument.

This essentially does the following transformation

```
/ {
	node {};
};
```
to

```
/ {
	label: node {};
};
```

such that when `mod-dtb.dtsi` uses `&label { prop = <val>; };` for example, it modifies `node {};` and adds `prop = <val>;` to it such that it becomes

```
/ {
	node { prop = <val>; };
};
```
