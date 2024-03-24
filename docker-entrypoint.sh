#!/bin/bash

set -e

APP_PATH=/var/www/app

create_project() {
    composer create-project laravel/laravel:^11.0 $APP_PATH

    chmod -R 775 $APP_PATH/storage
    chmod -R 775 $APP_PATH/bootstrap
}

start_project() {

    if [ ! $(id -u) != 0 ]; then
        chown -R $USER_ID:$USER_ID $APP_PATH
        chown -R www-data:www-data $APP_PATH/storage
        chown -R www-data:www-data $APP_PATH/bootstrap
    fi

    /usr/bin/supervisord -c /etc/supervisord.conf
}

if [ ! -f /var/www/app/artisan ]; then
    create_project
    sleep 1
    start_project
else
    start_project
fi

exit 0
~        
