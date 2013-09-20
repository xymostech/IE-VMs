#!/usr/bin/env bash

cmd=$1
vm=$2

function usage() {
    echo "Usage: manage.sh <command> <VM>"
    echo ""
    echo "Commands:"
    echo "  start, stop, setup, reset, connect"
    echo ""
    echo "Example: manage.sh reset IE8"
}

if [ $# -ne 2 ]
then
    usage
    exit 1
fi

if echo $vm | grep -qe "^IE[0-9]\+$"
then
    port=$(echo $vm | sed "s/^IE//")
else
    echo "Invalid IE version"
    usage
    exit 1
fi

case "$cmd" in
    start)
        echo "Starting $vm"
        qemu-system-i386 \
            -m 2047M \
            -enable-kvm \
            -vnc :$port \
            -monitor unix:$vm.sock,server,nowait \
            -no-reboot \
            -usbdevice tablet \
            -daemonize \
            -name $vm \
            $vm-overlay.qcow2
        ;;
    stop)
        echo "Stopping $vm"
        echo system_powerdown | socat - UNIX-CONNECT:$vm.sock
        ;;
    connect)
        echo "Connecting to $vm"
        socat stdio UNIX-CONNECT:$vm.sock
        ;;
    setup)
        echo "Setting up $vm"
        qemu-img create -b $vm.vmdk -f qcow2 $vm-overlay.qcow2
        ;;
    reset)
        echo "Resetting $vm"
        rm -f $vm-overlay.qcow2
        qemu-img create -b $vm.vmdk -f qcow2 $vm-overlay.qcow2
        ;;
    *)
        echo "Invalid command: $cmd"
        usage
        exit 1
        ;;
esac
