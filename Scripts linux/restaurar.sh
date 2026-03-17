#!/bin/bash
# Manuel Soltero Díaz
# Script para restaurar copias de la base de datos

# Comprobamos que ha introducido 5 parámetros
if [ "$#" -ne 5 ]; then
    echo "Uso: $0 <usuario> <base_de_datos> <ruta> <password> <nombre_copia>"
    exit 1
fi

# Asignamos variables a los parámetros
usuario=$1
nombre_base=$2
ruta=$3
password=$4
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

# Comprobamos que el fichero de copia existe
if [ ! -f "$ruta/$nombre_copia.sql.gz" ]; then
    echo "Error: El fichero '$ruta/$nombre_copia.sql.gz' no existe."
    exit 1
fi

# Restauramos la copia de seguridad
gunzip -c "$ruta/$nombre_copia.sql.gz" | mysql -u "$usuario" -p"$password" "$nombre_base"

# Comprobamos que la restauración se realizó correctamente
if [ $? -eq 0 ]; then
    echo "Restauración realizada correctamente en '$nombre_base'."
else
    echo "Error al restaurar la copia de seguridad."
    exit 1
fi