# dtb patcher for embedded devices
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
## 4. Get boot.img [to be done just once]
```
su
sh img.sh
exit
```
## 5. Modifications and recompiling

Edit mod.dtsi as needed, then recompile with

`./run.sh`

A flashable dtb-mod.zip will be pushed to /sdcard.

### Notes for those who want to adapt this for their devices

#### 1. Edit DT match string

Edit [this string](https://github.com/Jebaitedneko/dtb-recompiler-bash/blob/master/run.sh#L9) to what your device uses.

This can be found out easily by grabbing a DMESG from a normal boot cycle and search for any line with `(DT)` or `MACHINE`.

You should see a similar string. That is the name of the dtb that the kernel uses to identify the hardware layout and configurations of your device.

#### 2. update label arguments

The `label` function defined in `run.sh` takes an existing node name as the first argument and labels it with the label you provide as second argument.

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

such that when `mod.dtsi` uses `&label { prop = <val>; };` for example, it modifies `node {};` and adds `prop = <val>;` to it such that it becomes

```
/ {
	node { prop = <val>; };
};
```
