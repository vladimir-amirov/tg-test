#!/bin/bash
set -euo pipefail

dnf install -y nginx git
systemctl enable --now nginx

rm -rf /usr/share/nginx/html/*
git clone --depth 1 https://github.com/gabrielecirulli/2048.git /tmp/2048
cp -r /tmp/2048/* /usr/share/nginx/html/

systemctl restart nginx
