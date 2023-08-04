#!/bin/bash

if [ ! -f /var/www/wordpress/wp-config.php ]; then
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

cd /var/www/wordpress

wp core download --allow-root

mv /var/www/wp-config.php /var/www/wordpress/

wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306

wp core install  --allow-root \
        --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USR \
        --admin_password=$WP_ADMIN_PWD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email

wp user create $WP_USR $WP_EMAIL \
        --role=author \
        --user_pass=$WP__USR_PWD \
        --allow-root

fi

/usr/sbin/php-fpm7.3 -F