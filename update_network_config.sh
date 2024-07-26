#!/bin/bash

# Tìm địa chỉ IPv6
IPV6ADDR=$(ip -6 addr show dev ens3 | grep 'inet6' | grep -v 'fe80' | awk '{print $2}' | cut -d/ -f1)
echo "Tìm thấy địa chỉ IPv6: $IPV6ADDR"

# Tìm gateway IPv6
IPV6GATEWAY=$(ip -6 route show default | awk '{print $3}')
echo "Tìm thấy gateway IPv6: $IPV6GATEWAY"

# Kiểm tra nếu không tìm thấy địa chỉ IPv6 hoặc gateway
if [ -z "$IPV6ADDR" ] || [ -z "$IPV6GATEWAY" ]; then
  echo "Không tìm thấy địa chỉ IPv6 hoặc gateway."
  exit 1
fi

NETPLAN_CONFIG="/etc/netplan/01-netcfg.yaml"
BACKUP_CONFIG="/etc/netplan/01-netcfg.yaml.bak"

# Tạo bản sao lưu của file cấu hình Netplan hiện tại
sudo cp $NETPLAN_CONFIG $BACKUP_CONFIG

# Tạo file cấu hình Netplan mới
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

# Áp dụng cấu hình Netplan mới
sudo netplan apply

# Kiểm tra kết nối IPv6 trong 10 giây
ping6 -c 4 google.com
if [ $? -ne 0 ]; then
  echo "Cấu hình mới không hoạt động. Khôi phục lại cấu hình gốc."
  sudo cp $BACKUP_CONFIG $NETPLAN_CONFIG
  sudo netplan apply
  exit 1
else
  echo "Cấu hình mới hoạt động tốt."
fi 
