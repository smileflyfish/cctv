#!/bin/sh

#/bin/bash /home/pi/setup.sh start &
file="/home/pi/wvdial_log.txt"
if [ ! -f "$file" ]; then
    touch "$file"
    chmod 777 $file
else
    wvdial_size=`ls -l $file | awk '{print $5}'`
    echo $wvdial_size
    if [ $wvdial_size -ge 102400 ]; then
        rm -rf $file
        touch "$file"
        chmod 777 $file
    fi
fi

echo "-------------------------------" >> /home/pi/wvdial_log.txt
date >> /home/pi/wvdial_log.txt #

HW_OK=0
TIM=1

while [[ $HW_OK -ne 1 && $TIM -le 40 ]]
do
echo "while $HW_OK  $TIM"
echo $TIM >>  /home/pi/wvdial_log.txt
lsusb >> /home/pi/wvdial_log.txt
if sudo wvdial hw1 >> /home/pi/wvdial_log.txt 2>&1
then
	echo "ok"
	HW_OK=1
	echo "ok" >> /home/pi/wvdial_log.txt
else
	echo "false"
	echo "false" >> /home/pi/wvdial_log.txt
fi
TIM=$(($TIM+1))
sleep 10
echo "while1 $HW_OK  $TIM"
if [ $TIM -ge 10 ]; then
	reboot
fi
done
