# disk y USB

## info de dispositivos

    df -h                                        # dispositivos montados
    lsblk                                        # árbol de bloques
    sudo fdisk -l                                # todas las particiones

## montar USB

    sudo mount -o uid=<user>,gid=root,rw /dev/sdb3 /mnt/usb_1
    mount /dev/sd<X> /mnt/<carpeta>

## desmontar

    umount /mnt/<carpeta>
