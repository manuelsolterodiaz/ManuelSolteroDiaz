#!/bin/bash
# Script de aprovisionamiento del Balanceador de Carga Nginx
# Manuel Soltero Díaz

echo "=== Actualizando sistema ==="
apt-get update

echo "=== Instalando Nginx ==="
apt-get install -y nginx

echo "=== Configurando Nginx como balanceador de carga ==="
cat > /etc/nginx/conf.d/load-balancer.conf <<'EOF'
upstream backend_servers {
    server 192.168.20.10:80;
    server 192.168.20.11:80;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://backend_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Eliminar configuración por defecto
rm -f /etc/nginx/sites-enabled/default

echo "=== Habilitando y reiniciando Nginx ==="
systemctl enable nginx
systemctl restart nginx

# Eliminar ruta por defecto (el router gestiona el enrutamiento)
echo "=== Eliminando ruta por defecto ==="
ip route del default

echo "=== Balanceador configurado correctamente ==="