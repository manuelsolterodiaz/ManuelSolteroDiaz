#!/bin/bash
# Manuel Soltero Díaz
# Actualizar repositorios
sudo apt-get update

# Instalar MariaDB Server
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server mariadb-client

# Configurar MariaDB para escuchar en todas las interfaces
echo "=== Configurando MariaDB para aceptar conexiones remotas ==="
sudo sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Iniciar y habilitar MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Crear usuario admin con contraseña abcd
sudo mysql <<EOF
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;

CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

CREATE USER IF NOT EXISTS 'admin'@'192.168.40.12' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'192.168.40.12' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

# Reiniciar MariaDB para aplicar cambios
sudo systemctl restart mariadb

# Crear e importar la base de datos
echo "=== Creando base de datos IES_HORIZONTE ==="
sudo mysql < /vagrant/completo.sql

echo "=========================================="
echo "MariaDB instalado correctamente"
echo "Base de datos IES_HORIZONTE creada"
echo "Usuario: admin | Contraseña: abcd"
echo "Escuchando en: 0.0.0.0:3306"
echo "=========================================="

# Verificar que está escuchando
echo "=== Verificando puerto 3306 ==="
sudo netstat -tlnp | grep 3306 || sudo ss -tlnp | grep 3306

ip route del default