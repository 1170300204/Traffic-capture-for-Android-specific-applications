#!/bin/bash

for(( i=1; i <= 1; i++))
do
	echo $i;
	./FBop1.sh $i >./logs/${i}.log 2>&1;
	sleep 100;
	echo "done";
done