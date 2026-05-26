# SSH — permitir startx

    sudo vim /etc/X11/Xwrapper.config

Contenido:

    allowed_users=anybody
    needs_root_rights=yes
