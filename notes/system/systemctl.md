# systemctl

## servicios de usuario

    systemctl --user list-units --type=service
    systemctl --user list-unit-files --type=service --state=enabled
    systemctl --user list-units --type=service --state=running

## servicios del sistema

    systemctl list-units --type=service          # activos
    systemctl list-unit-files --type=service     # todos

## operaciones

    systemctl reload <servicio>                  # recargar config sin reiniciar
    systemctl is-enabled <servicio>              # verificar si está habilitado
    systemctl list-dependencies <servicio>       # dependencias
