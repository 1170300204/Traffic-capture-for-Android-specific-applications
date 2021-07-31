#!/bin/bash

source './ops.sh';

id=123456 # 设备ID，通过adb devices得到，并通过 adb -s $id 将命令发送到指定设备

time=$(date +%Y-%m-%d_%H:%M:%S_%N)
loop=$1;

getCoordinateByAttribution()
{
	instance=""
	instance=${instance:=$2}
	instance=${instance:=1}

	nl=`adb shell uiautomator dump 2>&1 `
	sleep 3

	# echo "cat sdcard/window_dump.xml|sed 's/>/\n/g'|grep "$1"|sed -n $2p"
	temp=`adb shell "cat sdcard/window_dump.xml|sed 's/>/\n/g'|grep "$1"|sed -n $2p"`
	temp=`echo ${temp%]\"*}`
	temp=`echo $temp|awk '{print $NF}'`

	count=0;
	while test "$temp" == ""; do

		swipe 500 1800 502 900 300
		nl=`adb shell uiautomator dump 2>&1 `
		sleep 3

		# echo "cat sdcard/window_dump.xml|sed 's/>/\n/g'|grep "$1"|sed -n $2p"
		temp=`adb shell "cat sdcard/window_dump.xml|sed 's/>/\n/g'|grep "$1"|sed -n $2p"`
		temp=`echo ${temp%]\"*}`
		temp=`echo $temp|awk '{print $NF}'`

		count=`expr ${count} + 1`
		if [ ${count} -eq 3 ]
		then 
			break
		fi

	done

	if test ! "$temp" == ""
	then
	temp=`echo ${temp/bounds=/}`
	temp=`echo $temp| sed 's/"//g'| sed 's/\[//g'| sed 's/\]/\n/g'`
	p1=`echo $temp|awk '{print $1}'`
	p2=`echo $temp|awk '{print $2}'`
	#定义四个变量，用例存储找到的属性的四个坐标值
	p1x=`echo ${p1%,*}`
	p1y=`echo ${p1#*,}`
	p2x=`echo ${p2%,*}`
	p2y=`echo ${p2#*,}`

	let centerX=$p1x/2+$p2x/2
	let centerY=$p1y/2+$p2y/2
	else
	#这里是查找属性失败时的动作
	echo `date +%m-%d-%H-%M-%S` getCoordinateByAttribution $1 failed >> log.txt
	fi
}

tapLike(){
	# 点赞
	getCoordinateByAttribution "赞按钮" 1;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "tapLike";
	sleep 1;
	click ${centerX} ${centerY};
	sleep 10;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "";
	sleep 1;
}

cancelLike(){
	# 取消赞
	getCoordinateByAttribution "赞按钮" 1;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "cancelLike";
	sleep 1;
	click ${centerX} ${centerY};
	sleep 10;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "";
	sleep 1;
}

comment(){
	# 评论
	getCoordinateByAttribution "评论按钮" 1;
	click ${centerX} ${centerY};
	sleep 2;
	adb shell input text "Good_$(date +%s%N | md5sum | head -c 10)";
	sleep 1;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "comment";
	sleep 0.5;
	click 990 1435;
	sleep 10;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "";
	sleep 1;
	click 770 2330;
	sleep 0.1;
	click 770 2330;
	sleep 2;

}

forward(){
	# 转发
	getCoordinateByAttribution "分享按钮" 1;
	sleep 0.5;
	click ${centerX} ${centerY};
	sleep 2;
	click 200 1400;
	sleep 0.5;
	adb shell input text "Good_$(date +%s%N | md5sum | head -c 10)";
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "forward";
	sleep 0.5;
	click 950 1430;
	sleep 10;

	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "";
	sleep 2;

}

postOnlyWords(){
	click 350 435;
	sleep 1;
	click 220 480;
	sleep 1;
	adb shell input text "$(date +%s%N | md5sum | head -c 15)";
	sleep 0.5;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "postOnlyWords";
	click 980 145;
	sleep 10;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "";
	sleep 2;

}

postWithPic(){
	click 350 435;
	sleep 1;
	click 233 1340;
	sleep 1;
	click 180 380;
	click 970 150;
	sleep 0.5;
	click 233 470;
	adb shell input text "$(date +%s%N | md5sum | head -c 15)";
	sleep 0.5;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "postWithPicture";
	click 980 145;
	sleep 10;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "";
	sleep 2;

}

browse(){
	# 浏览
	getCoordinateByAttribution "帖子菜单" 1;
	sleep 0.5;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "browse";
	sleep 1;
	click `expr ${centerX} - 300` ${centerY};
	sleep 10;
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);
	echo "";
	click 770 2330;
	sleep 2;
}

total1(){

	swipe 500 1800 502 800 300;
	sleep 0.1;
	tapLike;
	sleep 1;
	cancelLike;
	sleep 1;
	# swipe 500 1800 502 800 300;
	# sleep 0.1;
	# tapLike;
	# sleep 1;
	# cancelLike;
	# sleep 1;
	# swipe 500 1800 502 800 300;
	# sleep 0.1;
	# tapLike;
	# sleep 1;
	# cancelLike;
	# sleep 1;

	click 100 150;
	sleep 1;
	swipe 500 1800 502 800 300;
	sleep 0.1;
	forward;
	sleep 1;
	# swipe 500 1800 502 800 300;
	# sleep 0.1;
	# forward;
	# sleep 1;
	# swipe 500 1800 502 800 300;
	# sleep 0.1;
	# forward;
	# sleep 1;

	click 100 150;
	sleep 1;
	swipe 500 1800 502 800 300;
	sleep 0.1;
	comment;
	sleep 1;
	# swipe 500 1800 502 800 300;
	# sleep 0.1;
	# comment;
	# sleep 1;
	# swipe 500 1800 502 800 300;
	# sleep 0.1;
	# comment;
	# sleep 1;

	click 100 150;
	sleep 1;
	swipe 500 1800 502 800 300;
	sleep 0.1;
	browse;
	sleep 1;
	# swipe 500 1800 502 800 300;
	# sleep 0.1;
	# browse;
	# sleep 1;
	# swipe 500 1800 502 800 300;
	# sleep 0.1;
	# browse;
	# sleep 1;

	click 100 150;
	sleep 1;
	postOnlyWords;
	sleep 1.5;
	# postOnlyWords;
	# sleep 1.5;
	# postOnlyWords;
	# sleep 1.5;
	postWithPic;
	sleep 1.5;
	# postWithPic;
	# sleep 1.5;
	# postWithPic;
	# sleep 1.5;
}

start_tcpdump() {
	echo "start tcpdump";
	echo $(date +%Y-%m-%d_%H:%M:%S_%N);

	adb shell "su -c '/data/local/tcpdump -i nflog:10246 -w /sdcard/facebook/${loop}.pcap'";
}

dojob_finish() {
	sleep 2;
	echo " ";

	echo "#start";
	echo " ";
	total1;
	sleep 2;

	echo "#end";
	echo " ";
	adb shell "su -c 'killall -SIGINT tcpdump'";

	sleep 0.5;
	adb pull sdcard/facebook/${loop}.pcap ${loop}.pcap ;
	tar zcf ${loop}.zip ${loop}.pcap logs/${loop}.log && rm -f ${loop}.pcap ;
	mv ./${loop}.zip ./data/${loop}.zip
	adb shell "su -c 'rm sdcard/facebook/${loop}.pcap'"

	# adb shell screencap -p sdcard/${loop}.png;
	# adb pull sdcard/${loop}.png ./FBdata200PNG/${loop}.png ;
	# adb shell "su -c 'rm sdcard/${loop}.png'"

}

start_tcpdump&
dojob_finish&