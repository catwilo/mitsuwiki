# wifi — rfkill

Si `ip link set wlan0 up` falla con `Operation not possible due to RF-kill`:

    rfkill list                  # verificar estado
    rfkill unblock wifi          # desbloquear
