# Practica-IAW-1.5- HTTPS con Let’s Encrypt y Certbot

## Pasos previos a la instalación

**para la instalación vamos a tener que crear la siguiente estructura de directorios y archivos:**

![](imagenes/directorio-1.4.png)

**Una vez creados los archivos y directorios, procedemos a la instalación de las herramientas.**

## Creación y configuración de un certificado SSL/TLS autofirmado en Apache

## 1. Creación del archivo `setup_selfsigned_certificate` para la automatización de la creación del certificado SSL/TLS

### Paso 1. Importamos el archivo de variables y mostramos los comandos que se van ejecutando 

```
source .env
```

```
set -ex
```

### Paso 2. Creamos el certificado autofirmado

```
openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=$OPENSSL_COUNTRY/ST=$OPENSSL_PROVINCE/L=$OPENSSL_LOCALITY/O=$OPENSSL_ORGANIZATION/OU=$OPENSSL_ORGUNIT/CN=$OPENSSL_COMMON_NAME/emailAddress=$OPENSSL_EMAIL"
```

> [!NOTE]  
> 

### Paso 3. Clonamos el repositorio de la aplicación en /tmp

```
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp
```

### Paso 4. Movemos el código fuente de la aplicación a /var/www/html

```
mv /tmp/iaw-practica-lamp/src/* /var/www/html
```

> [!NOTE]  
> Lo movemos a otro sitio ya que lo habíamos descargado en un directorio temporal, que eso significa que a la hora de reiniciar o apagar la máquina, el repositorio desaparece del directorio al ser temporal.

### Paso 5. Configuramos el archivo config.php

```
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php
```

> [!IMPORTANT]  
> Este archivo lo modificamos ya que el original tiene unas variables que no tenemos y que si dejamos el archivo tal cual como viene del repositorio pues no funcionaría. Así que, con el comando `sed -i` lo cambiamos con nuestras variables que tenemos en el archivo `.env`.

### Paso 6. Creamos una base de datos de ejemplo

```
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME"
```

### Paso 7. Creamos un usuario para la base de datos de ejemplo


```
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%'"
```

### Paso 8. Configuramos el script de SQL con el nombre de la base de datos

```
sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql
```

> [!IMPORTANT]  
> Este archivo también le tenemos que cambiar una variable ya que la que viene definida no la tenemos y no funcionaría así que con el comando `sed -i` lo cambiamos con nuestras variables que tenemos en el archivo `.env`.

### Paso 9. Creamos las tablas de la base de datos

```
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql
```

### Paso 10. Comprobación de que el despliegue web funciona

![](imagenes/DespliegueWeb.png)