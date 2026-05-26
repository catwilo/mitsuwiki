# scp entre SSH

> ADVERTENCIA: sobrescribe el destino sin preguntar.

## copiar directorio

    scp -P 8022 -r carpeta/ user@host:~/

## copiar archivo

    scp archivo user@host:/path/destino
