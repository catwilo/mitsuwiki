# nmap

## flags rápidas

    nmap -F <ip>              # puertos comunes
    nmap -T4 <ip>             # timing agresivo
    nmap -sn <ip>             # solo ping
    nmap -Pn <ip>             # sin ping, asume activo
    nmap -n <ip>              # sin DNS
    nmap -sS <ip>             # SYN scan (sigiloso)
    nmap -sV -T4 <ip>         # versión de servicios
    nmap -A -T4 <ip>          # full: OS, versión, scripts

## escaneo completo rápido

    sudo nmap -p- --open -sS --min-rate 5000 -n -sV -Pn -vvv <ip>

## flujo: todos los puertos -> escaneo específico

    ports=$(sudo nmap -p- --min-rate=1000 -Pn -T4 <ip> \
        | grep '^[0-9]' | cut -d/ -f1 | tr '
' , | sed 's/,$//')
    sudo nmap -p$ports -Pn -sC -sV <ip>
