#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

apt update
apt install -y aptitude vim build-essential python-setuptools

add-apt-repository -y ppa:webupd8team/java
apt update
aptitude -y install oracle-java8-installer

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
apt update
aptitude -y install elasticsearch

echo "deb http://packages.elastic.co/kibana/4.5/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kinbana.list
apt update
aptitude install -y kibana

sudo aptitude install -y nginx

echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users

echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list.d/logstash.list
apt update
aptitude install -y logstash



echo "Remember to edit /etc/elasticsearch/elasticsearch.yml to 'network.host: localhost'\n"
echo "Remember to edit /opt/kibana/config/kibana.yml to 'server.host \"localhost\"'\n"


