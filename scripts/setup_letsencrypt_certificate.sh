#!/bin/bash

#Para mostrar los comandos que se van ejecutando
set -ex

#Importamos las variables de entorno
source .env

#Instalamos y actualizamos snap
snap install core
snap refresh core

#Eliminamos instalaciones previas de certbot con apt
apt remove certbot -y

#instalamos el cliente de certbot 
snap install --classic certbot

#Creamos una alias para el comando certbot
sudo ln -fs /snap/bin/certbot /usr/bin/certbot