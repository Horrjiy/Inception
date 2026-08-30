#!/usr/bin/env sh

if  wp core is-installed --allow-root ; then  
    echo "wordpress has already been set up!"
else
    chown -R www-data:www-data /var/www/html
    wp core download --allow-root
    wp config create --dbname=${MDB_DATABASE} --dbuser=${MDB_USER} --dbpass=${MDB_PASSWORD} --dbhost=${DBHOST}:3306 --allow-root

    wp core install --url=mpoplow.42.fr --title="Schaschenk!" --admin_user=${WPAD_USER} --admin_password=${WPAD_PASSWORD} --admin_email=${WPAD_EMAIL} --allow-root
    wp user create zweier zwei@drei.vier --user_pass=${ZWEIER_PASSWORD} --allow-root
fi

exec php-fpm8.2 -F
