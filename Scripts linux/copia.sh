#!/bin/bash
# Manuel Soltero Díaz
# Script para hacer copias de la base de datos

# Comprobamos que ha introducido 5 parámetros
if [ "$#" -ne 5 ]; then
    echo "Uso: $0 <usuario> <password> <base_de_datos> <ruta> <nombre_copia>"
    exit 1
fi

# Asignamos variables a los parámetros
usuario=$1
password=$2
nombre_base=$3
ruta=$4
nombre_copia=$5

# Comprobamos que el usuario existe en MySQL
if ! mysql -u "$usuario" -p"$password" -e "SELECT 1;" &>/dev/null; then
    echo "Error: No se puede conectar con el usuario '$usuario'. Verifica usuario y contraseña."
    exit 1
fi

# Comprobamos que la base de datos existe
if ! mysql -u "$usuario" -p"$password" -e "USE \`$nombre_base\`;" &>/dev/null; then
    echo "Error: La base de datos '$nombre_base' no existe o '$usuario' no tiene acceso."
    exit 1
fi

# Comprobamos que la ruta de destino existe
if [ ! -d "$ruta" ]; then
    echo "Error: La ruta '$ruta' no existe."
    exit 1
fi

# Realizamos la copia de seguridad
mysqldump -u "$usuario" -p"$password" "$nombre_base" | gzip > "$ruta/$nombre_copia.sql.gz"

# Comprobamos que el volcado se realizó correctamente
if [ $? -eq 0 ]; then
    echo "Copia realizada correctamente: $ruta/$nombre_copia.sql.gz"
else
    echo "Error al realizar la copia de seguridad."
    exit 1
fi

# Eliminamos copias de más de 30 días
find "$ruta" -name "*.sql.gz" -type f -mtime +30 -exec rm -f {} \;