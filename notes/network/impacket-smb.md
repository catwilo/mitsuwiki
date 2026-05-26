# impacket — SMB

## instalar

    pipx install impacket

## cliente SMB sin password

    smbclient.py guest@<host> -no-pass

## servidor SMB local (compartir directorio actual)

    sudo $(which smbserver.py) -smb2support share $(pwd)
