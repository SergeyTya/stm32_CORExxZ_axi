#!/bin/bash

(

while [ True ]
do
	echo mdw 0x2000002c 1
	sleep 1

done

) | telnet localhost 4444 
