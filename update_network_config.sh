#!/bin/bash

# Đường dẫn đến tập tin cần chỉnh sửa
FILE_PATH="/etc/sysconfig/network-scripts/ifcfg-eth0"

# Nội dung mới để thay thế
NEW_CONTENT=$(cat <<EOF
# Created by cloud-init on instance boot automatically, do not edit.
BOOTPROTO=dhcp
DEVICE=eth0
DHCPV6C=yes
HWADDR=fa:16:3e:af:61:43
IPV6INIT=yes
IPV6_AUTOCONF=no
ONBOOT=yes
TYPE=Ethernet
USERCTL=no

IPV6ADDR=2407:5b40:0:43f::2a4/64
IPV6_DEFAULTGW=2407:5b40:0:43f::1
EOF
)

# Xóa nội dung cũ và thêm nội dung mới vào tập tin
echo "$NEW_CONTENT" > $FILE_PATH

# Khởi động lại dịch vụ mạng (tùy thuộc vào hệ thống của bạn)
systemctl restart network

echo "Đã cập nhật và khởi động lại dịch vụ mạng."
