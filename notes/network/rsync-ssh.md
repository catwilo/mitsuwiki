# rsync entre SSH

> Orden: SOURCE primero, TARGET segundo.

## copiar solo archivos que faltan

    rsync -avz --ignore-existing user@host:/src/ /dest/

## copiar archivos con mismo nombre pero diferente contenido

    rsync -avz --checksum user@host:/src/ /dest/
