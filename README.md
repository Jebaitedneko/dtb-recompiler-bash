# DTB & DTBO patcher

Primarily aimed at doing quick dtb/dtbo modifications if you don't have immediate access
to a build system or pc

Currently, this repo is configured to produce dtb and dtbo for Xiaomi Poco X3 Pro for the following

dtb-mod: GPU OC/UC/UV
dtbo-mod: Panel ESD Fixup

## 1. Download tmux and install required packages for tmux

#### Downloads

[Download tmux from here (Play store one is deprecated)](https://f-droid.org/repo/com.termux_117.apk)

[\[BETA\] Latest debug build (extract zip and install apk from within)](https://github.com/termux/termux-app/suites/4044720919/artifacts/102504345)

#### Install the termux pre-requisites for this toolkit with

```
pkg install git zip dtc python
```
## 2. Allow storage permissions for tmux
![](https://github.com/Jebaitedneko/dtb-recompiler-bash/raw/318074366be0a6b290fe689b01bdfce91165bcae/demo-tmux-storage-perm.jpg)

## 3. Clone this repo & enter into it
```
git clone --depth=1 https://github.com/Jebaitedneko/dtb-recompiler-bash drc && cd drc
```
## 4. Pull boot and dtbo to repo [to be done just once]

#### Type each command manually one after the other

`su`

`sh img.sh`

`exit`

## 5. Generating the modified dtb/dtbo zips

#### DTB

`./run-dtb.sh`

A flashable dtb-mod.zip will be pushed to /sdcard.

#### DTBO

`./run-dtbo.sh`

A flashable dtbo-mod.zip will be pushed to /sdcard.

## Modifications (for devs)

#### DTB Modding

Edit mod.dtsi as needed

#### DTBO Modding

Modding done via `push_node` function call.

```
push_node "node_name" '
prop-0;
prop-1 = <val>;
prop-2 = [f0 0f];
prop-3 - "str";
'

```

node_name must exist within the dtbo, as we are applying a local fixup to node_name.

As with the case of dtbo, you can't perform deletions of nodes and properties.


Otherwise, use dtb modder if the node is defined there.


DTBO Mod method is there primarily for nodes which are absent in the base dtb.


Things like sde panels work this way as they were abstracted out from the base dtb for decluttering.


It is to be noted that the second agument be passed within single quotes.


Manually escape any double quotes in the properties if you are planning to use double quotes anyways.

Edit `run-dtbo.sh` and add new `push_node` function calls as needed.

### Notes for those who want to adapt this for their devices

#### 1. Edit DT match string [DTB/DTBO]

#### [DTB]
Edit [this string](https://github.com/Jebaitedneko/dtb-recompiler-bash/blob/master/run-dtb.sh#L8) to what your device uses.

#### [DTBO]
Edit [this string](https://github.com/Jebaitedneko/dtb-recompiler-bash/blob/master/run-dtbo.sh#L8) to what your device uses.

This can be found out easily by grabbing a DMESG from a normal boot cycle and search for any line with `(DT)` or `MACHINE`.

You should see a similar string. That is the name of the dtb that the kernel uses to identify the hardware layout and configurations of your device.

#### 2. update label arguments [DTB]

The `label` function defined in `run-dtb.sh` takes an existing node name as the first argument and labels it with the label you provide as second argument.

## Technical Details [dtb-mod]

It essentially does the following transformation:

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

## Technical Details [dtbo-mod]

Firstly, several fragments are generated with pure additions to the base dtb. (you can't perform node/property deletions here unlike in dtb)

Here, each node label is put under `__symbols__ {};`, each of which point to different fragments.

Fragments are then modified (purely overrides / more additions only) via `__local_fixups__ {};`.

And the entire thing is wrapped around in conventional dtb starting syntax just like dtb `/ {};`.

As for modding the dtbo, we are taking advantage of any existing local fixups done over the base fragment and adding our props into it.

## Disabled VBMETAs

```
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
```
```
fastboot --disable-verity --disable-verification flash vbmeta_system vbmeta_system.img
```

[vbmeta.img](https://github.com/Jebaitedneko/dtb-recompiler-bash/raw/4699aae8aa880b905d8d5d60e13b02e318d92a29/vbmeta.img)

[vbmeta_system.img](https://github.com/Jebaitedneko/dtb-recompiler-bash/raw/4699aae8aa880b905d8d5d60e13b02e318d92a29/vbmeta_system.img)

## DEMO

![](https://github.com/Jebaitedneko/dtb-recompiler-bash/raw/318074366be0a6b290fe689b01bdfce91165bcae/demo.gif)
