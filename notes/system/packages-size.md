# listar paquetes por tamaño (Arch/pacman)

## top paquetes instalados por tamaño

    pacman -Qi | egrep '^(Name|Installed)' | cut -f2 -d':' | tr '
K' ' 
' | sort -nrk 2 | less

## gráfico de dependencias

    pacgraph -c
