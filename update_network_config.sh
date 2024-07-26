#!/bin/bash

# Đường dẫn đến tập tin Netplan mới
FILE_PATH="/etc/netplan/01-netcfg.yaml"

# Nội dung mới để thay thế
NEW_CONTENT=$(cat <<EOF
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      dhcp6: true
      addresses:
        - 2407:5b40:0:43f::2a4/64
      gateway6: 2407:5b40:0:43f::1
EOF
)

# Tạo hoặc ghi đè nội dung vào tập tin Netplan
echo "$NEW_CONTENT" > $FILE_PATH

# Áp dụng cấu hình Netplan
netplan apply

echo "Đã cập nhật và áp dụng cấu hình mạng."

