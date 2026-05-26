# NFS — compartir carpeta limitado a interfaz

## instalar

    # host y VM:
    sudo pacman -S nfs-utils

## configurar export (host)

    sudo mkdir -p /etc/exports.d
    echo "/home/$USER/scripts 192.168.250.0/24(rw,no_root_squash,sync)" \
        | sudo tee /etc/exports.d/scripts.exports

    sudo systemctl start nfs-server
    sudo exportfs -ra
    sudo exportfs -v

## montar desde VM

    sudo mkdir -p /mnt/scripts
    sudo mount -t nfs 192.168.250.1:/home/user/scripts /mnt/scripts

## desmontar

    sudo umount /mnt/scripts
