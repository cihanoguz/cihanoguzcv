#!/bin/bash
# Public CV site. The PDF is https://cihanoguzcv.oguzlab.com/cv.pdf
set -euo pipefail

NAME=cihanoguzcv.oguzlab.com
SITE=/etc/nginx/sites-available/cihanoguzcv
CERT=/etc/letsencrypt/live/${NAME}/fullchain.pem
install -d -m 755 /var/www/certbot

write_site() {
  if [[ -f "${CERT}" ]]; then
    cat > "${SITE}" << EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${NAME};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name ${NAME};

    ssl_certificate /etc/letsencrypt/live/${NAME}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${NAME}/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_pass http://127.0.0.1:8082;
    }
}
EOF
  else
    cat > "${SITE}" << EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${NAME};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_pass http://127.0.0.1:8082;
    }
}
EOF
  fi
  ln -sfn "${SITE}" /etc/nginx/sites-enabled/cihanoguzcv
  nginx -t
  systemctl reload nginx
}

write_site

public_name="$(dig +short ${NAME} A @1.1.1.1 | awk '/^[0-9.]+$/' | head -n 1 || true)"
if [[ ! -f "${CERT}" && "${public_name}" == "46.224.38.112" ]]; then
  certbot certonly --webroot -w /var/www/certbot -d "${NAME}" \
    --non-interactive --agree-tos -m cihanoguz@oguzlab.com
  write_site
fi

if [[ -f "${CERT}" ]]; then
  echo "CV site listens on 443"
else
  echo "CV site listens on 80 until ${NAME} points at this server"
fi
