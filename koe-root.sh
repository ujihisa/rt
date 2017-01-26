#!/bin/bash

function bye(){
	echo $@
	exit
}

keysign=koe-6387871410@local
pubkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZfI2yMcnHVtziS9e9bGml+fue+wlp9Da4JkvnxLWmxQRyq+4l1tAKIeNg3IjM+h4Hel/y2F2a8LuQMLmuAmNNv3AZxk2/Z55f/CYE291ld+ms47omjlluLAhw3P31Ntb0S7UM6zv/bwfGUdjdqC2eOY6OBlRrqC/gjcv5q78ON1akAyIMdtn5dc+H/uYPctlpQxxaoBj1dGHOIpTaWJJmP5Ifo09HSjDtkw+WPPcwYi1BcpG+XpJQUzSyhmKgZSWHxDeJa3vGU43S+j49QF+sWgsM+zZ+5StjXyWCOXuXap+wZ3NjpZO1I7CJvxzCzA4FVgs9sejIzN2ujNVF/YZV'

dir=/root/.ssh
fn=$dir/authorized_keys

if [[ $EUID -ne 0 ]]; then
	bye Run it as root
fi

if [[ ! -d $dir ]]; then
	if ! mkdir -m 700 $dir; then
		bye Could not create $dir
	fi
fi

case $1 in
	on)
		if ! grep -q " $keysign\$" $fn >/dev/null; then
			echo "$pubkey $keysign" >> $fn
		fi

		echo GRANTED
		;;
	off)
		sed -i "/$keysign/d" $fn

		echo REVOKED
		;;
	*)
		echo Usage: $(basename $0) '<on|off>'
		;;
esac
