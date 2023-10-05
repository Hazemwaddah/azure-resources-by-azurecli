# This is a configuration file for Nginx to use
# HTTPS based on the official video from Nginx
# on Youtube.com
# Link:  https://www.youtube.com/watch?v=X3Pr5VATOyA&ab_channel=NGINX%2CInc
events{}
http {
    include /etc/nginx/mime.types;
   server {
        listen 80 default_server;
        server_name >[REDACTED-DOMAIN] api->[REDACTED-DOMAIN];
        return 301 http://$server_name$request_uri;
          }
   server {
        listen 443 ssl;
        server_name >[REDACTED-DOMAIN] api->[REDACTED-DOMAIN];
        ssl_certificate /etc/nginx/ssl/backend-tls.crt;
        ssl_certificate_key /etc/nginx/ssl/backend-tls.key;
     location / {
        root /usr/share/nginx/html;
        index index.html index.html;
                }
          }
     }