#!/bin/bash

echo "Server"

PORT=2021

PROT_NAME="ABFP"
HANDSHAKE="THIS_IS_MY_CLASSROOM"
OUTPUT_PATH="salida_server/"


echo "(0) ALEJANDRO BIG F****G PROTOCOL"

echo "(1) Listening $PORT"

HEADER=`nc -l -p $PORT`
PREFIX=`echo $HEADER | cut -d " " -f 1`
IP_CLIENT=`echo $HEADER | cut -d " " -f 2`

echo "TEST HEADER"

echo "(4) Response HEADER"

if [ "$PREFIX" != $PROT_NAME ]; then 
echo "Error Cabecera"
sleep 1
echo "KO_CONN" | nc -q 1 $IP_CLIENT $PORT
exit 1
fi

sleep 1
echo "OK_CONN" | nc -q 1 $IP_CLIENT $PORT

echo "(5) Listening"

CLIENT_HANDSHAKE=`nc -l -p $PORT`
echo "TEST"


if [ "$CLIENT_HANDSHAKE" != $HANDSHAKE ]; then
echo "Wrong handshake"
sleep 1
echo "KO_HANDSHAKE" | nc -q 1 $IP_CLIENT $PORT
exit 2 
fi
echo "(8a) Response"
sleep 1
echo "YES_IT_IS" | nc -q 1 $IP_CLIENT $PORT

echo "(8b) Listen num_files"

NUM_FILES=`nc -l -p $PORT`
PREFIX=`echo $NUM_FILES | cut -d " " -f 1`
NUM=`echo $NUM_FILES | cut -d " " -f 2`

if [ "$PREFIX" != "NUM_FILES" ]; then
	echo "ERROR: Prefijo NUM_FILES incorrecto"

	sleep 1
	echo "KO_NUM_FILES" | nc -q 1 $IP_CLIENT $PORT
	exit 3
fi

sleep 1
echo "OK_NUM_FILES" | nc -q 1 $IP_CLIENT $PORT

echo "NUM FILES: $NUM"

for NUMBER in `seq $NUM`; do 

	echo "(9) Listening names"

	FILE_NAME=`nc -l -p $PORT`
	PREFIX=`echo $FILE_NAME | cut -d " " -f 1`
	NAME=`echo $FILE_NAME | cut -d " " -f 2`
	MD5_NAME=`echo $FILE_NAME | cut -d " " -f 3`

	echo "TEST"

	if [ "$PREFIX" != "FILE_NAME" ]; then 
		echo "Error: worng prefix"
		sleep 1
		echo "KO_FILE_NAME" | nc -q 1 $IP_CLIENT $PORT
		exit 4
	fi

	MD5_CHECK=`echo $NAME | md5sum | cut -d " " -f 1`

	if [ "$MD5_CHECK" != "$MD5_NAME" ]; then 
		echo "Error: worng file name"
		sleep 1
		echo "KO_FILE_NAME" | nc -q 1 $IP_CLIENT $PORT
		exit 5
	fi
	echo "(12) Response FILE_NAME"
	sleep 1
	echo "OK_FILE_NAME" | nc -q 1 $IP_CLIENT $PORT

#Para enviar mail

#	echo "(12.b) mail"
#	echo "$NAME" | mail -s "Nombre del archivo recibido" alejandro_test@mailinator.com

	echo "(13) Listening"

	nc -l -p $PORT > $OUTPUT_PATH$NAME

done

echo "(16) Response"

sleep 1
echo "OK_DATA" | nc -q 1 $IP_CLIENT $PORT


echo "(17) Listening"

GOODBYE=`nc -l -p $PORT`

if [ "$GOODBYE" != "ABFP GOOD_BYE" ]; then
	echo "WORNG DISSCONECT"
	exit 6
fi

exit 0
