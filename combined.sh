#!/bin/bash

########################################GRAFANA INSTALLATION################################################

### create a file grafana.repo in yum repos
touch /etc/yum.repos.d/grafana.repo

### copy the content to the above created file grafana.repo
echo "
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt " > /etc/yum.repos.d/grafana.repo

### install grafana
yum install grafana -y

### start grafana as service
service grafana-server start

### configure the Grafana server to start at boot time
/sbin/chkconfig --add grafana-server

###########################################ELASTICSEARCH INSTALLATION#############################################

### create a file elasticsearch.repo in yum repos
touch /etc/yum.repos.d/elasticsearch.repo

### copy the content to the above created file elasticsearch.repo
echo "
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md " > /etc/yum.repos.d/elasticsearch.repo

### install elasticsearch
yum install elasticsearch -y

### change java path
sed -i '/JAVA_HOME=/ c\ JAVA_HOME=/usr/lib/jvm/zulu8.46.0.19-ca-jdk8.0.252-linux_x64/' /etc/sysconfig/elasticsearch

### making changes in elasticsearch.yml file
sed -i '/path.data: /path/to/data/ c\ path.data: /var/lib/elasticsearch' /etc/elasticsearch/elasticsearch.yml
sed -i '/path.logs: /path/to/logs/ c\ path.logs: /var/log/elasticsearch' /etc/elasticsearch/elasticsearch.yml

### start elasticsearch as service
service elasticsearch start

### configure the elasticsearch to start at boot time
/sbin/chkconfig --add elasticsearch

#######################INSTALLING HEARTBEAT##################################
### install heartbeat
yum -y install heartbeat-elastic

#########################INSTALLING METRICBEAT###############################
### install metricbeat
yum -y install metricbeat

