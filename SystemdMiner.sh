#!/bin/bash

echo "[+] systemdminer killer starting"

# 清理病毒文件
rm -f ~/.systemd-login
rm -f /lib/systemd/systemd-login
rm -f /tmp/.X1M-unix
rm -f /tmp/.systemd-analyze
rm -f /tmp/6Tx3Wq

# 锁定/tmp目录下的随机名病毒文件
path = '/tmp'
files = $(ls -a $path)
for filename in $files
do
	file_path=$path/$filename
	if [ -f $file_path ]
	then
		file_md5=$(md5sum $file_path | cut -d ' ' -f1)
		if [ $file_md5=='42483ee317716f87687ddb79fedcb67b' ]
		then
			echo 'found' $file_path
			# rm -f $file_path
			echo 0 > $file_path
			chattr +i $file_path
		fi
	fi
done

# 清理病毒定时任务
crontab -r
rm /etc/cron.d/systemd

echo "[+] finish"
