#!/bin/sh

#Прием ссылки в переменную
outline_link=$1

#Не пустая ли строка?
if [ -z "$outline_link" ]; 
then
	echo 'Впишите в первый аргумент Outline VPN ссылку'
	exit 1
fi

#Обработка строки ссылки
decoded_base64=$(echo -n "$outline_link" | cut -d '@' -f 1 | cut -b 6- | base64 -di);

crypt_method=$(echo -n $decoded_base64 | cut -d ':' -f 1);
password=$(echo -n $decoded_base64 | cut -d ':' -f 2);
ip_address=$(echo -n $outline_link | cut -d '@' -f 2 | cut -d ':' -f 1);
port=$(echo -n $outline_link | cut -d '@' -f 2 | cut -d ':' -f 2 | cut -d '/' -f 1);

default_local_address=127.0.0.1
default_local_port=1080
default_timeout=600

#Запись в файл результата
echo "{
     \"server\": \"$ip_address\",
     \"server_port\": $port,
     \"password\": \"$password\",
     \"local_address\": \"$default_local_address\",
     \"local_port\": $default_local_port,
     \"method\": \"$crypt_method\",
     \"timeout\": $default_timeout
}" > ./config.json;

#Запуск прокси с настроенным конфигом
#sudo ss-local -v -c ./config.json
