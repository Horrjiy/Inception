FROM debian:bookworm
RUN apt-get update && apt-get upgrade -y && apt install -y

RUN apt install php php-fpm php-mysql php-curl -y

COPY conf/www.conf /etc/php/8.2/fpm/pool.d
COPY script.sh /usr/local/bin

RUN chmod +x /usr/local/bin/script.sh
ENTRYPOINT [ "/usr/local/bin/script.sh" ]
