FROM debian:bookworm
RUN apt-get update && apt-get upgrade -y && \
    apt install mariadb-server mariadb-client -y

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld
RUN sed -i "s/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf

COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT [ "/usr/local/bin/script.sh" ]