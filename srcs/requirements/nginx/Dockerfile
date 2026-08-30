FROM debian:bookworm
RUN apt-get update && apt-get install -y nginx openssl
   
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/key.pem \
        -out /etc/nginx/ssl/cert.pem \
        -subj "/CN=mpoplow.42.fr"

COPY conf/nginx.config /etc/nginx/sites-available/default
COPY conf/nginx.config /etc/nginx/conf.d/default
RUN rm -f /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

CMD ["nginx", "-g", "daemon off;"]