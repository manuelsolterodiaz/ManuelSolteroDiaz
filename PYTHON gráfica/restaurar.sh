#!/bin/bash
# Manuel Soltero Díaz
# Script para hacer restaurar copias de la base de datos


#Comprobamos que ha introducido 5 parámetros
if [ "$#" -ne 5 ]; then 
exit 1 
    fi

#Asignamos variables a los parámetros

usuario=$1
nombre_base=$2
ruta=$3
password=$4
nombre_copia=$5


gunzip -c "$ruta/$nombre_copia.sql.gz" | mysql -u "$usuario" -p"$password" "$nombre_base"
