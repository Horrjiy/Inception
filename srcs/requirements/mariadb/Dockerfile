FROM debian:bookworm
RUN apt-get update && apt-get upgrade -y && \
    apt install mariadb-server mariadb-client -y

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT [ "/usr/local/bin/script.sh" ]