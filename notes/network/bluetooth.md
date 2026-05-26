# bluetooth

## instalar

    sudo pacman -S bluez bluez-utils
    sudo systemctl start bluetooth

## emparejar dispositivo

    bluetoothctl
    power on
    agent on
    default-agent
    scan on
    pair XX:XX:XX:XX:XX:XX
    connect XX:XX:XX:XX:XX:XX
    trust XX:XX:XX:XX:XX:XX      # evitar reemparejar en el futuro
    scan off
    exit

## audio por bluetooth

    pactl set-default-sink $(pactl list sinks short | grep bluez | awk '{print $1}')
