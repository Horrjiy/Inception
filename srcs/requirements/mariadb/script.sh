#!/usr/bin/env sh

mariadbd --user=root &
SERVER_PID=$!
mariadb-admin --wait=30 ping

mariadb -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MDB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MDB_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MDB_USER}'@'%' IDENTIFIED BY '${MDB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MDB_DATABASE}\`.* TO '${MDB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

kill "$SERVER_PID"
wait "$SERVER_PID"

exec mariadbd --user=root --bind-address=0.0.0.0

## DEBUG

# echo
# echo "────────────────────────────────────────"
# echo "  Root password : ${MDB_ROOT_PASSWORD}"
# echo "  Database      : ${MDB_DATABASE}"
# echo "  User          : ${MDB_USER}"
# echo "  User password : ${MDB_PASSWORD}"
# echo "────────────────────────────────────────"
# echo