#!/bin/bash

for(( i=1; i <= 1; i++))
do
	echo $i;
	./FBop1.sh $i >./logs/${i}.log 2>&1;
	sleep 100; //根据执行一次FBop1.sh的时间进行修改，单位为秒(s)
	echo "done";
done
