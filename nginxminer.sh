#!/bin/bash

# 上次修改时间 --> 2020-6-30
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgank/nginxminer-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgank/nginxminer-$time/" ]
then
    # 创建定时任务、文件、进程备份目录
    mkdir -p $log_dir
    mkdir -p $log_dir/crontab
    mkdir -p $log_dir/file
    mkdir -p $log_dir/process
    touch $log_file
fi

echo "[+] start clean --> $(date)" | tee -a $log_file


# --------------------------------------------------
# 函数定义

# 文件清除函数
kill_file()
{
    if [ -f "$1" ]
    then
        cp -n $1 $log_dir/file
        chattr -ia $1
        echo 'botgank' > $1
        chattr +ia $1
        echo "[+] clean file --> $1" | tee -a $log_file
    fi
}

# 目录清除函数
kill_dir()
{
    if [ -d "$1" ]
    then
        cp -r $1 $log_dir/file
        rm -rf $1
        echo "[+] clean dir --> $1" | tee -a $log_file
    fi
}

# 进程清除函数
kill_proc()
{
    if [ -n "$(echo $1 | egrep '[0-9]{3,6}')" ]
    then
        proc_name=$(basename $(ps -fp $1 | awk 'NR>=2 {print $8}'))
        cat /proc/$1/exe >> $log_dir/process/$1-$proc_name.dump
        echo "[+] clean process --> $(ps -fp $1 | awk 'NR>=2 {print $2,$8}')" | tee -a $log_file
        kill -9 $1
    fi
}

# 定时任务清除函数
kill_cron()
{
    cron_dirs=("/var/spool/cron/" "/etc/cron.d/" "/etc/cron.hourly/")
    for cron_dir in ${cron_dirs[@]}
    do
        if [ -n "$(grep -r $1 $cron_dir)" ]
        then
            crontab=$(grep -r $1 $cron_dir)
            cron_file=$(grep -r $1 $cron_dir | awk '{print $1}' | cat | cut -d : -f 1 | uniq)
            cp -n $cron_file $log_dir/crontab
            chattr -ia $cron_file
            sed -i "/$1/d" $cron_file > /dev/null 2>&1
            if [ $? != 0 ]
            then
                echo '' > $cron_file
            fi
            echo "[+] clean crontab --> $crontab" | tee -a $log_file
        fi
    done
}

# --------------------------------------------------
# 清除NginxMiner病毒进程

# 添加免疫文件
if [ -f "/usr/bin/nginx" ]
then
    if [ -n "$(grep 'upx' /usr/bin/nginx)" ]
    then
        echo "botgank" > /usr/bin/nginx
        chattr +ia /usr/bin/nginx
        echo "[+] add antifile --> /usr/bin/nginx" | tee -a $log_file
    fi
else
    echo "botgank" > /usr/bin/nginx
    chattr +ia /usr/bin/nginx
    echo "[+] add antifile --> /usr/bin/nginx" | tee -a $log_file
fi

# 遍历寻找198.199.127.168地址挖矿进程
miner_pids="$(netstat -antp | grep '198.199.127.168' | awk '{print $7}' | cut -d "/" -f 1 | sort -u)"
if [ -n "$miner_pids" ]
then
    for miner_pid in $miner_pids; do kill_proc $miner_pid; done
fi

# 遍历寻找3333端口挖矿进程
miner_pids="$(netstat -antp | grep ':3333' | awk '{print $7}' | cut -d "/" -f 1 | sort -u)"
if [ -n "$miner_pids" ]
then
    for miner_pid in $miner_pids; do kill_proc $miner_pid; done
fi

# 遍历寻找nginx挖矿进程
proc_ids="$(ps -elf | grep 'nginx' | grep -v grep | awk '{print $4}')"
if [ -n "$proc_ids" ]
then
    for proc_id in $proc_ids
    do
        if [ -n "$(readlink /proc/$proc_id/exe | grep /dev/shm/.nginx | grep delete)" ]
        then
            kill_proc $proc_id
        fi
    done
fi

# --------------------------------------------------
# 清除NginxMiner病毒目录
kill_dir "/dev/shm/.nginx/"

# --------------------------------------------------
# 清除NginxMiner定时任务
kill_cron '\/dev\/shm\/\.nginx'

echo "[+] end clean --> $(date)" | tee -a $log_file