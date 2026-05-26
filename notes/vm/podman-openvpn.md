# podman-openvpn

Setup completo de servidor OpenVPN dentro de un contenedor Podman con systemd.

## instalar y crear contenedor

    sudo pacman -S podman
    podman pull alpine
    podman run -it --privileged --cap-add=NET_ADMIN \
      --device /dev/net/tun:/dev/net/tun \
      --name vpn0 --network bridge \
      -p 56201:56201 alpine
    apk update && apk add openvpn easy-rsa

## generar certificados (easy-rsa)

    mkdir /etc/openvpn/easy-rsa && cd /etc/openvpn/easy-rsa
    cp -r /usr/share/easy-rsa/* .
    ./easyrsa init-pki
    ./easyrsa build-ca
    ./easyrsa gen-req myserver nopass
    ./easyrsa sign-req server myserver
    ./easyrsa gen-dh
    openvpn --genkey secret ta.key
    ./easyrsa gen-req cliente1 nopass
    ./easyrsa sign-req client cliente1

## server.conf (/etc/openvpn/server.conf)

    port 56201
    proto tcp
    dev tun
    ca /etc/openvpn/easy-rsa/pki/ca.crt
    cert /etc/openvpn/easy-rsa/pki/issued/myserver.crt
    key /etc/openvpn/easy-rsa/pki/private/myserver.key
    dh /etc/openvpn/easy-rsa/pki/dh.pem
    tls-auth /etc/openvpn/easy-rsa/pki/ta.key 0
    server 10.8.0.0 255.255.255.0
    push "redirect-gateway def1 bypass-dhcp"
    push "dhcp-option DNS 1.1.1.1"
    keepalive 10 120
    data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305
    persist-key
    persist-tun
    user nobody
    group nogroup
    verb 3

## ejecutar y guardar imagen

    openvpn --config /etc/openvpn/server.conf
    podman commit vpn0 vpn_imagen
    podman cp vpn0:/etc/openvpn/client.ovpn ~/client.ovpn

## systemd como user (~/.config/systemd/user/vpn0.service)

    [Unit]
    Description=OpenVPN in Podman Container
    After=network.target

    [Service]
    ExecStart=/usr/bin/podman start -a vpn0
    ExecStop=/usr/bin/podman stop vpn0
    Restart=on-failure

    [Install]
    WantedBy=default.target

    systemctl --user daemon-reload
    systemctl --user enable vpn0.service
    systemctl --user start vpn0.service

## comandos utiles

    podman logs -f vpn0
    podman exec -it vpn0 /bin/sh
    podman stop vpn0
    podman cp vpn0:/etc/openvpn/server.conf ~/server.conf.bak
