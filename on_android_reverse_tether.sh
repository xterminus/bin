#!/system/bin/sh

if [ "$1" = "up" ]; then
    echo 1 > /sys/class/usb_composite/rndis/enable
 
    ip addr add 192.168.200.2/24 dev usb0
    ip link set usb0 up
    ip route delete default
    ip route add default via 192.168.200.1
    setprop net.dns1 192.168.200.1
    /data/local/bin/dropbear
fi

if [ "$1" = "down" ]; then
    sleep 2
    ip route delete default
    ip link set usb0 down
    killall dropbear
    echo 0 > /sys/class/usb_composite/rndis/enable
fi
