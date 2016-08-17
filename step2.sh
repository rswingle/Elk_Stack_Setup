#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

cd /etc/pki/tls

openssl req -config /etc/ssl/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt

cd ~/elk_install

cp beats /etc/logstash/conf.d/02-beats-input.conf

cp syslog /etc/logstash/conf.d/10-syslog-filter.conf

cp esearch /etc/logstash/conf.d/30-elasticsearchoutput.conf

systemctl restart logstash
systemctl enable logstash

cd ~

curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.2.2.zip
unzip beats-dashboards-*.zip

cd beats-dashboards-*
bash load.sh

cd ~
curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json
curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json

