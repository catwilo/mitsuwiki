# sshfs — montar directorios via SSH

## montar

    sshfs -p 8022 user@192.168.1.1:/ruta/remota /mnt/local/

## ver montados

    mount | grep sshfs

## desmontar

    umount /mnt/local/
