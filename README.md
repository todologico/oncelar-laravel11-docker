## Oncelar - Laravel 11 - Docker Listo para Instalar 
### Laravel 11 - MariaDB - Phpmyadmin

<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

**Instalación:**  

Clonar el repositorio.  

Situados en /oncelar, desde la consola ejecutar el siguiente comando, el cual creara las carpeta "db" (volumen mariadb) y "src" (codigo laravel) y levantará los contenedores de los tres servicios.

**mkdir -p src && mkdir -p db && USER_ID=$(id -u) docker-compose up -d**  

El contenedor de laravel se visualiza en http://localhost:83/  

El contenedor de phpmyadmin se visualiza en http://localhost:89/  

Configuracion acceso DB en file .env que se ingresa automaticamente desde el file entrypoint 

DB_CONNECTION=mysql  
DB_HOST=oncelar-db  
DB_PORT=3310  
DB_DATABASE=oncelar  
DB_USERNAME=oncelar  
DB_PASSWORD=00000000  

**COMANDOS CON PHP ARTISAN DENTRO DEL CONTENEDOR**

Al construir el contenedor se da de alta un usuario no root (your_user), con el cual es necesario loguearse dentro del mismo.
Este usuario pertenece al grupo www-data, por lo cual puede acceder a realizar comandos artisan.  

Para dar de alta este usuario, en el Dockerfile estoy agregando:

ARG DEBIAN_FRONTEND=noninteractive  
ARG USER_NAME=your_user  
ARG USER_UID=1000  
RUN useradd -u $USER_UID -ms /bin/bash $USER_NAME  
RUN usermod -aG www-data $USER_NAME  

y para poder correr comandos, se ingresa al contenedor y se cambia de usuario, corriendo:

docker exec -it oncelar bash

revisamos todos los usuarios, verificando que el nuestro se encuentra activo:

cat /etc/passwd

cambiamos al usuario no root:

su your_user

verificamos que accedemos a artisan:

php artisan

Opcionalmente puede hacerse directamente desde el interior del contenedor:  

docker exec -it oncelar bash  
adduser your_user  
usermod -aG www-data your_local_user  
id nuevo_usuario  

lo que deberia mostrar:  

uid=1000(your_local_user) gid=1000(your_local_user) groups=1000(your_local_user),33(www-data)





--------------------------------------


PRUEBAS DE CONECTIVIDAD DB CON TINKER
1) docker exec -it oncelar php artisan tinker
2) use Illuminate\Support\Facades\DB; DB::connection()->getPdo();
