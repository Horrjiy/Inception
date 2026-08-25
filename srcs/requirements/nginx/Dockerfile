FROM debian:bookworm
RUN apt-get update && apt-get install -y nginx openssl
   
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/key.pem \
        -out /etc/nginx/ssl/cert.pem \
        -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Student/CN=mpoplow.42.fr"

COPY conf/nginx.config /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]