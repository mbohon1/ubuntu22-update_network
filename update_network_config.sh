#!/bin/bash

# Tìm địa chỉ IPv6 và gateway
IPV6ADDR=$(ip -6 addr show dev ens3 | grep 'inet6' | grep -v 'fe80' | awk '{print $2}' | cut -d/ -f1)
IPV6GATEWAY=$(ip -6 route show default | awk '{print $3}')

# Kiểm tra nếu không tìm thấy địa chỉ IPv6 hoặc gateway
if [ -z "$IPV6ADDR" ] || [ -z "$IPV6GATEWAY" ]; then
  echo "Không tìm thấy địa chỉ IPv6 hoặc gateway."
  exit 1
fi

NETPLAN_CONFIG="/etc/netplan/01-netcfg.yaml"

# Tạo file cấu hình Netplan
cat <<EOT > $NETPLAN_CONFIG
network:
  version: 2
  ethernets:
    ens3:
      dhcp4: true
      addresses:
        - $IPV6ADDR/64
      routes:
        - to: default
          via: $IPV6GATEWAY
      nameservers:
        addresses:
          - 2001:4860:4860::8888
          - 2001:4860:4860::8844
EOT

# Áp dụng cấu hình Netplan
sudo netplan apply

# Kiểm tra kết nối IPv6
ping6 google.com -c 4
