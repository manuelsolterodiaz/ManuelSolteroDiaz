#!/bin/bash
# Manuel Soltero Díaz
# Script para hacer copias de la base de datos


#Comprobamos que ha introducido 5 parámetros
if [ "$#" -ne 5 ]; then 
exit 1 
    fi

#Asignamos variables a los parámetros
usuario=$1
password=$2
nombre_base=$3
ruta=$4
nombre_copia=$5



mysqldump -u "$usuario" -p"$password" "$nombre_base" | gzip > "$ruta/$nombre_copia.sql.gz"

# Eliminamos copias de más de 30 días
find "$ruta" -name "*.sql.gz" -type f -mtime +30 -exec rm -f {} \;