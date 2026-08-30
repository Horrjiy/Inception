FROM debian:bookworm
RUN apt-get update && apt-get upgrade -y
RUN apt install php php-fpm php-mysql php-curl curl -y

RUN mkdir -p /var/www/html
WORKDIR /var/www/html

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/bin/wp
RUN chmod +x /usr/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d
COPY script.sh /usr/local/bin

RUN chmod +x /usr/local/bin/script.sh
ENTRYPOINT [ "/usr/local/bin/script.sh" ]