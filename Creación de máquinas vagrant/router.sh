#!/bin/bash
# Script de aprovisionamiento del Router
# Manuel Soltero Díaz

export DEBIAN_FRONTEND=noninteractive

apt-get update


# 1. HABILITAR IP FORWARDING  #

echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/^#\?net.ipv4.ip_forward=.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p


# 2. NAT PARA SALIDA A INTERNET (eth0)      

# eth0 = interfaz NAT (10.0.2.15)
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o eth0 -j MASQUERADE

# 3. PERMITIR TRÁFICO DE LA LAN HACIA INTERNET (FORWARD)  #

# Regla general para permitir salida
iptables -A FORWARD -s 192.168.10.0/24 -o eth0 -j ACCEPT

# Permitir tráfico
iptables -A FORWARD -s 192.168.10.0/24 -o eth0 -p icmp -j ACCEPT
iptables -A FORWARD -s 192.168.10.0/24 -o eth0 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 192.168.10.0/24 -o eth0 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -s 192.168.10.0/24 -o eth0 -p udp --dport 53 -j ACCEPT

# Permitir respuestas
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

# 4. REDIRECCIÓN HTTP AL BALANCEADOR                      

iptables -t nat -A PREROUTING -s 192.168.10.0/24 -p tcp --dport 80 \
 -j DNAT --to-destination 192.168.20.14:80

iptables -t nat -A POSTROUTING -d 192.168.20.14 -p tcp --dport 80 \
  -j MASQUERADE


# 5. GUARDAR REGLAS DE IPTABLES               
apt-get install -y iptables-persistent
netfilter-persistent save

exit 0
