# sync — verificar escritura de caché

Garantiza que todos los datos en caché se escriban al disco antes de apagar
o desmontar un dispositivo.

    sync

## con progreso

    sync; while [ $(pgrep -x sync | wc -l) -gt 0 ]; do sleep 1; done
