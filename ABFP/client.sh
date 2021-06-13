#!/bin/bash

echo "ALEJANDRO BIG F*****G PROTOCOL Cliente"

PORT=2021
INPUT_PATH="entrada_cliente/"
IP_CLIENT="127.0.0.1"

if [ "$1" == "" ]; then
	IP_SERVER="127.0.0.1"
else
	IP_SERVER="$1"
fi


echo "(2) Seanding headers to $IP_SERVER"

echo "ABFP $IP_CLIENT" | nc -q 1 $IP_SERVER $PORT

echo "(3) Listening"

RESPONSE=`nc -l -p $PORT`

if [ "$RESPONSE" != "OK_CONN" ]; then
echo "Error: Connection refused"
exit 1
fi
echo "TEST"

echo "(6) Handshake"

sleep 1
echo "THIS_IS_MY_CLASSROOM" | nc -q 1 $IP_SERVER $PORT

echo "(7a) Listening"

RESPONSE=`nc -l -p $PORT`

echo "TEST"

if [ "$RESPONSE" != "YES_IT_IS" ]; then
echo "Error HANDSHAKE"
exit 2
fi


#enviar num archivos a enviar
echo "(7b) Num files"

sleep 1
NUM_FILES=`ls $INPUT_PATH | wc -w`

echo "NUM_FILES $NUM_FILES" | nc -q 1 $IP_SERVER $PORT

echo "(10.b) Listening"
RESPONSE=`nc -l -p $PORT`

if [ "$RESPONSE" != "OK_NUM_FILES" ]; then
 echo "ERROR: Prefijo NUM_FILES incorrecto"
 exit 3
fi

for FILE_NAME in `ls $INPUT_PATH`; do


FileMD5=`echo $FILE_NAME | md5sum | cut -d " " -f  1`  

	echo "(10) File names"

	sleep 1

	
	echo "FILE_NAME $FILE_NAME $FileMD5" | nc -q 1 $IP_SERVER $PORT

	echo "(11) LISTEN"

	RESPONSE=`nc -l -p $PORT`
	echo "TEST"
	if [ "$RESPONSE" != "OK_FILE_NAME" ]; then
		echo "Error:FILENAME send"
	exit 3
	fi

	echo "(14) Data"

	sleep 1 
	cat $INPUT_PATH$FILE_NAME | nc -q 1 $IP_SERVER $PORT

done 


echo "(15) Listening"

RESPONSE=`nc -l -p $PORT`
if [ "$RESPONSE" != "OK_DATA" ]; then
echo "Error: data sended failed"
exit 4
fi

echo "(18) Goodbye"

sleep 1
echo "ABFP GOOD_BYE" | nc -q 1 $IP_SERVER $PORT

exit 0
