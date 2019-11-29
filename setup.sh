#!/bin/bash

cd /opt/
git clone 'https://github.com/fabricat/prometheus-openstack-exporter.git'
cd prometheus-openstack-exporter/


apt install python-prometheus-client

tee /etc/default/prometheus-openstack-exporter > /dev/null <<EOT
NOVARC=/root/admin-openrc
CONFIG_FILE=/etc/prometheus-openstack-exporter/prometheus-openstack-exporter.yaml
EOT



mkdir /etc/prometheus-openstack-exporter
tee /etc/prometheus-openstack-exporter/prometheus-openstack-exporter.yaml > /dev/null <<EOT
listen_port: 9183
cache_refresh_interval: 300  # In seconds
cache_file: /var/cache/prometheus-openstack-exporter/italy
cloud: Italy
openstack_allocation_ratio_vcpu: 2.5
openstack_allocation_ratio_ram: 1.1
openstack_allocation_ratio_disk: 1.0
log_level: INFO

# Configure the enabled collectors here.  Note that the Swift account
# collector in particular has special requirements.
enabled_collectors:
  - cinder
  - neutron
  - nova

# To export hypervisor_schedulable_instances metric set desired instance size
schedulable_instance_size:
    ram_mbs: 4096
    vcpu: 2
    disk_gbs: 20

# Uncomment if the cloud doesn't provide cinder / nova volumes:
#use_nova_volumes: False

EOT



mkdir /var/cache/prometheus-openstack-exporter/
touch /var/cache/prometheus-openstack-exporter/italy





cp prometheus-openstack-exporter.service /etc/systemd/system
systemctl daemon-reload
systemctl start prometheus-openstack-exporter.service

