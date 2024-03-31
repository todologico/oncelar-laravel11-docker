#!/bin/bash

set -e

APP_PATH=/var/www/app

# primera funcion
create_project() {

    composer create-project laravel/laravel:^11.0 $APP_PATH

    chmod -R 775 $APP_PATH/storage
    chmod -R 775 $APP_PATH/bootstrap

     # Modificar el archivo .env con search y replace al inicializar
    sed -i 's/DB_CONNECTION=.*/DB_CONNECTION=mysql/' /var/www/app/.env
    sed -i 's/# DB_HOST=.*/DB_HOST=oncelar-db/' /var/www/app/.env
    sed -i 's/# DB_PORT=.*/DB_PORT=3310/' /var/www/app/.env
    sed -i 's/# DB_DATABASE=.*/DB_DATABASE=oncelar/' /var/www/app/.env
    sed -i 's/# DB_USERNAME=.*/DB_USERNAME=oncelar/' /var/www/app/.env
    sed -i 's/# DB_PASSWORD=.*/DB_PASSWORD=00000000/' /var/www/app/.env
    sed -i 's/SESSION_DRIVER=.*/SESSION_DRIVER=file/' /var/www/app/.env

}

# segunda funcion
start_project() {
   
    chown -R www-data:www-data $APP_PATH/storage
    chown -R www-data:www-data $APP_PATH/bootstrap
   
    #iniciando el demonio Supervisor para controlar php y nginx
    # Supervisor is a client/server system that allows its users to monitor and control a number of processes on UNIX-like operating systems.
    /usr/bin/supervisord -c /etc/supervisord.conf
}

## llamado a funciones de inicializacion si no existe el file artisan
if [ ! -f /var/www/app/artisan ]; then
    create_project
    sleep 1
    start_project

## proyecto ya iniciado, solo hago starter
else
    start_project
fi

exit 0
~        
