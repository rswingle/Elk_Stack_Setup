#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

systemctl restart elasticsearch
systemctl daemon-reload
systemctl enable elasticsearch

systemctl daemon-reload
systemctl enable kibana
systembtl start kibana

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig
cp ~/nginx_sites-available_default /etc/nginx/sites-available/default

nginx -t
systemctl restart nginx

ufw allow 'Nginx Full'

mkdir -p /etc/pki/tls/certs
mkdir /etc/pki/tls/private

echo "Change /etc/ssl/openssl.cnf subjectAltName = IP: 192.168.1.30"

ufw allow 5044


