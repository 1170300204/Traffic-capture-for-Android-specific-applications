#!/bin/bash

click() {
    # echo "click: ($1, $2)";
    adb shell input touchscreen tap $1 $2;
}

swipe() {
	# echo "swipe: ($1, $2, $3, $4, $5)";
	adb shell input swipe $1 $2 $3 $4 $5;
}