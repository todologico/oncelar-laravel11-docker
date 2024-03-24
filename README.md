## Oncelar - Laravel 11 - Docker  
### Laravel 11 - MariaDB - Phpmyadmin

**Instalación:**  

Clonar el repositorio.  

Situados en /oncelar, desde la consola ejecutar los comandos docker:

mkdir -p src && mkdir -p db
USER_ID=$(id -u) docker-compose up -d  

Configuracion acceso DB en file .env:  

DB_CONNECTION=mysql  
DB_HOST=oncelar-db  
DB_PORT=3310  
DB_DATABASE=oncelar  
DB_USERNAME=oncelar  
DB_PASSWORD=00000000  

**COMANDOS CON PHP ARTISAN DENTRO DEL CONTENEDOR**

Al construir el contenedor se da de alta un usuario no root (your_local_user), con el cual es necesario loguearse dentro del mismo.
Este usuario pertenece al grupo www-data, por lo cual puede acceder a realizar comandos artisan.  

Para dar de alta este usuario, en el Dockerfile estoy agregando:

ARG DEBIAN_FRONTEND=noninteractive  
ARG USER_NAME=your_local_user  
ARG USER_UID=1000  
RUN useradd -u $USER_UID -ms /bin/bash $USER_NAME  
RUN usermod -aG www-data $USER_NAME  

y para poder correr comandos, se ingresa al contenedor y se cambia de usuario, corriendo:

docker exec -it oncelar bash

revisamos todos los usuarios, verificando que el nuestro se encuentra activo:

cat /etc/passwd

cambiamos al usuario no root:

su your_local_user

verificamos que accedemos a artisan:

php artisan

--------------------------------------


PRUEBAS DE CONECTIVIDAD DB CON TINKER
1) docker exec -it oncelar php artisan tinker
2) use Illuminate\Support\Facades\DB; DB::connection()->getPdo();
