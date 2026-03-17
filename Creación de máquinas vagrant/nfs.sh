#!/bin/bash
# Script de aprovisionamiento del Servidor NFS con PHP-FPM
# Manuel Soltero Díaz

echo "=== Actualizando sistema ==="
apt-get update

echo "=== Instalando NFS Server, PHP-FPM y extensiones ==="
apt-get install -y nfs-kernel-server php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip unzip

echo "=== Creando directorio compartido ==="
mkdir -p /var/www/html

echo "=== Configurando exportación NFS ==="
cat > /etc/exports <<'EOF'
/var/www/html 192.168.30.11(rw,sync,no_subtree_check,no_root_squash)
/var/www/html 192.168.30.12(rw,sync,no_subtree_check,no_root_squash)
EOF

exportfs -a

echo "=== Configurando PHP-FPM para escuchar en todas las interfaces ==="
PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')

# Escuchar en 0.0.0.0:9000 para aceptar conexiones remotas
sed -i 's/listen = \/run\/php\/php.*-fpm.sock/listen = 0.0.0.0:9000/' /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

# Permitir conexiones solo desde los servidores web
sed -i 's/;listen.allowed_clients/listen.allowed_clients/' /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
sed -i '/listen.allowed_clients/d' /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
echo "listen.allowed_clients = 192.168.30.11,192.168.30.12" >> /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

echo "=== Creando archivo index.html de bienvenida ==="
cat > /var/www/html/index.html <<'EOF'
pagina de ies horizonte
EOF

echo "=== Ajustando permisos ==="
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "=== Reiniciando servicios ==="
systemctl enable nfs-kernel-server
systemctl restart nfs-kernel-server
systemctl enable php$PHP_VERSION-fpm
systemctl restart php$PHP_VERSION-fpm

echo "=== Verificando configuración PHP-FPM ==="
netstat -tlnp | grep 9000 || ss -tlnp | grep 9000

echo "=== Servidor NFS con PHP-FPM configurado correctamente ==="
ip route del default