#!/bin/bash

status_code=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/todos)

echo "Validar si la url es valida"
echo $status_code
if [ $status_code = 200 ]
then
    echo "URL correcta"
    echo "Validar busqueda de codigo inexistente"
    status_code=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/todos/CODIGO_INEXISTENTE)
    if [ $status_code = 404 ]
    then
        echo "No se encontro un codigo con valor CODIGO_INEXISTENTE"
		echo "Validar si existen elementos"
		totalElements=$(curl -s $BASE_URL/todos | jq -r length)
		if [ $totalElements = 0 ]
		then
		    echo "No hay elementos registrados"
		else
		    echo "Existen $totalElements elementos"
			echo "Validar que se puede consultar el primer elemento"
			firstElement=$(curl -s $BASE_URL/todos | jq -r '.[0].id' | tr -d '\n\t')
			status_code=$(curl -s -o /dev/null -w "%{http_code}"  $BASE_URL/todos/$firstElement)
			if [ $status_code = 200 ]
			then
			    echo "El primer elemento se busco correctamente"
			else
			    echo "No funcionó la búsqueda de elemento existente"
				exit 1
			fi
		fi
    else
        echo "El endpoint no funciona correctamente"
        exit 1
    fi
else
    echo "La url no es correcta"
    exit 1
fi
