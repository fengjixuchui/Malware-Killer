#!/bin/bash

# --------------------------------------------------
# 创建备份目录，以清除时间命名
time=$(date | awk '{print $5}')
log_file="/tmp/botgank/$time.log"
if [ ! -d "/tmp/botgank/" ]
then
    # 创建定时任务、文件、进程备份目录
    mkdir /tmp/botgank/
    touch $log_file
fi

# --------------------------------------------------
# 函数定义

# ddg检测函数
check_ddg()
{
    echo "[+] start check ddg" >> $log_file

    # 检测定时任务 i.sh
    if [ "$(grep -r '/i.sh' /var/spool/cron/)" ]
    then
        echo "[+] found ddg crontab --> $(grep -r '/i.sh' /var/spool/cron/)" | tee -a $log_file
    fi

    # 检测定时任务 ddgs
    if [ "$(grep -r '67.205.168.20' /var/spool/cron/)" ]
    then
        echo "[+] found ddg crontab --> $(grep -r '67.205.168.20' /var/spool/cron/)" | tee -a $log_file
    fi

    # 检查 SSH 密钥后门
    if [ -f "/root/.ssh/authorized_keys" ]
    then
        if [ "$(grep "AAAAB3NzaC1yc2EAAAADAQABAAABAQDfxLBb" /root/.ssh/authorized_keys)" ]
        then
            echo "[+] found ddg ssh --> $(grep "AAAAB3NzaC1yc2EAAAADAQABAAABAQDfxLBb" /root/.ssh/authorized_keys)" | tee -a $log_file
        fi
    fi

    echo "[+] end check ddg" >> $log_file
}

# billgates检测函数
check_billgates()
{
    echo "[+] start check billgates" >> $log_file

    # 检测文件 /tmp/gates.lod
    if [ -f '/tmp/gates.lod' ]
    then
        if [ "$(cat /tmp/gates.lod)" != "botgank" ]
        then
            echo "[+] found billgates file --> /tmp/gates.lod" | tee -a $log_file
        fi
    fi

    # 检测文件 /tmp/moni.lod
    if [ -f '/tmp/moni.lod' ]
    then
        if [ "$(cat /tmp/moni.lod)" != "botgank" ]
        then
            echo "[+] found billgates file --> /tmp/moni.lod" | tee -a $log_file
        fi
    fi

    # 检测文件 /usr/bin/bsd-port/getty.lock
    if [ -f '/usr/bin/bsd-port/getty.lock' ]
    then
        if [ "$(cat /usr/bin/bsd-port/getty.lock)" != "botgank" ]
        then
            echo "[+] found billgates dir --> /usr/bin/bsd-port/getty.lock" | tee -a $log_file
        fi
    fi

    echo "[+] end check billgates" >> $log_file
}

# systemminer检测函数
check_systemminer()
{
    echo "[+] start check systemminer" >> $log_file

    # 检测定时任务1
    # 若存在带有base64字符串的随机名sh脚本，则是systemdminer创建的定时任务
    if [ "$(grep -r "\......\.sh" /var/spool/cron/ | awk '{print $6}' | xargs sed -n "/base64 -d/p")" ]
    then
        echo "[+] found systemminer crontab --> $(grep -r "\......\.sh" /var/spool/cron/)" | tee -a $log_file
    fi

    # 检测定时任务2
    # 若存在带有base64字符串的随机名sh脚本，则是systemdminer创建的定时任务
    if [ "$(grep -r "\/opt\/.....\.sh" /etc/cron.d/ | awk '{print $7}' | xargs sed -n "/base64 -d/p")" ]
    then
        echo "[+] found systemminer crontab --> $(grep -r "\/opt\/.....\.sh" /etc/cron.d/)" | tee -a $log_file
    fi
  
    echo "[+] end check systemminer" >> $log_file
}

# startminer检测函数
check_startminer()
{
    echo "[+] start check startminer" >> $log_file

    # 检测定时任务 xmi
    if [ -n "$(grep -r '\/xmi' /var/spool/cron/)" ]
    then
        echo "[+] found startminer crontab --> $(grep -r '\/xmi' /var/spool/cron/)" | tee -a $log_file
    fi

    # 检测定时任务 hehe.sh
    if [ -n "$(grep -r 'hehe.sh' /var/spool/cron/)" ]
    then
        echo "[+] found startminer crontab --> $(grep -r 'hehe.sh' /var/spool/cron/)" | tee -a $log_file
    fi

    # 检测定时任务 start.jpg
    if [ -n "$(grep -r 'start.jpg' /var/spool/cron/)" ]
    then
        echo "[+] found startminer crontab --> $(grep -r 'start.jpg' /var/spool/cron/)" | tee -a $log_file
    fi

    if [ -f '/var/tmp/ss2.py' ]
    then
        if [ "$(cat /var/tmp/ss2.py)" != "botgank" ]
        then
            echo "[+] found startminer file --> /var/tmp/ss2.py" | tee -a $log_file
        fi
    fi

    if [ -f '/var/tmp/ss3.py' ]
    then
        if [ "$(cat /var/tmp/ss3.py)" != "botgank" ]
        then
            echo "[+] found startminer file --> /var/tmp/ss3.py" | tee -a $log_file
        fi
    fi

    if [ -f '/tmp/go' ]
    then
        if [ "$(cat /tmp/go)" != "botgank" ]
        then
            echo "[+] found startminer file --> /tmp/go" | tee -a $log_file
        fi
    fi

    if [ -f '/var/tmp/xd.json' ]
    then
        if [ "$(cat /var/tmp/xd.json)" != "botgank" ]
        then
            echo "[+] found startminer file --> /var/tmp/xd.json" | tee -a $log_file
        fi
    fi

    if [ -f '/var/tmp/sustse' ]
    then
        if [ "$(cat /var/tmp/sustse)" != "botgank" ]
        then
            echo "[+] found startminer file --> /var/tmp/sustse" | tee -a $log_file
        fi
    fi

    if [ -f '/tmp/java' ]
    then
        if [ "$(cat /tmp/java)" != "botgank" ]
        then
            echo "[+] found startminer file --> /tmp/java" | tee -a $log_file
        fi
    fi

    echo "[+] end check startminer" >> $log_file
}

# xorddos检测函数
check_xorddos()
{
    echo "[+] start check xorddos" >> $log_file

    # 检测定时任务
    if [ -f "/etc/cron.hourly/udev.sh" ]
    then
        if [ "$(cat /etc/cron.hourly/udev.sh)" != "botgank" ]
        then
            echo "[+] found xorddos crontab --> /etc/cron.hourly/udev.sh" | tee -a $log_file
        fi
    fi

    if [ -f "/etc/cron.hourly/gcc.sh" ]
    then
        if [ "$(cat /etc/cron.hourly/gcc.sh)" != "botgank" ]
        then
            echo "[+] found xorddos crontab --> /etc/cron.hourly/gcc.sh" | tee -a $log_file
        fi
    fi

    if [ -f "/etc/cron.hourly/gcc4.sh" ]
    then
        if [ "$(cat /etc/cron.hourly/gcc4.sh)" != "botgank" ]
        then
            echo "[+] found xorddos crontab --> /etc/cron.hourly/gcc4.sh" | tee -a $log_file
        fi
    fi

    if [ -f "/etc/cron.hourly/cron.sh" ]
    then
        if [ "$(cat /etc/cron.hourly/cron.sh)" != "botgank" ]
        then
            echo "[+] found xorddos crontab --> /etc/cron.hourly/cron.sh" | tee -a $log_file
        fi
    fi

    # 检测病毒驱动
    if [ -f "/lib/libgcc4.so" ]
    then
        if [ "$(cat /lib/libgcc4.so)" != "botgank" ]
        then
            echo "[+] found xorddos file --> /lib/libgcc4.so" | tee -a $log_file
        fi
    fi

    if [ -f "/lib/libudev.so" ]
    then
        if [ "$(cat /lib/libudev.so)" != "botgank" ]
        then
            echo "[+] found xorddos file --> /lib/libudev.so" | tee -a $log_file
        fi
    fi

    if [ -f "/lib/libudev4.so" ]
    then
        if [ "$(cat /lib/libudev4.so)" != "botgank" ]
        then
            echo "[+] found xorddos file --> /lib/libudev4.so" | tee -a $log_file
        fi
    fi

    # 检测病毒文件
    if [ -f "/lib/udev/debug" ]
    then
        if [ "$(cat /lib/udev/debug)" != "botgank" ]
        then
            echo "[+] found xorddos file --> /lib/udev/debug" | tee -a $log_file
        fi
    fi

    if [ -f "/lib/udev/udev" ]
    then
        if [ "$(cat /lib/udev/udev)" != "botgank" ]
        then
            echo "[+] found xorddos file --> /lib/udev/udev" | tee -a $log_file
        fi
    fi

    if [ -f "/lib/udev/dev" ]
    then
        if [ "$(cat /lib/udev/dev)" != "botgank" ]
        then
            echo "[+] found xorddos file --> /lib/udev/dev" | tee -a $log_file
        fi
    fi

    echo "[+] end check xorddos" >> $log_file
}

# lsdminer检测函数
check_lsdminer()
{
    echo "[+] start check lsdminer" >> $log_file

    # 若存在带有 lsd.systemten.org 字符串的定时任务
    if [ -n "$(grep -r "lsd\.systemten\.org" /var/spool/cron/)" ]
    then
        echo "[+] found lsdminer crontab --> $(grep -r "lsd\.systemten\.org" ./)" | tee -a $log_file
    fi

    # 若存在带有 aliyun.one 字符串的定时任务
    if [ -n "$(grep -r "aliyun\.one" /var/spool/cron/)" ]
    then
        echo "[+] found lsdminer crontab --> $(grep -r "aliyun\.one" ./)" | tee -a $log_file
    fi

    # 若存在带有 pastebin.com/raw/******** 字符串的定时任务
    if [ -n "$(grep -Er "pastebin\.com\/raw\/........" /var/spool/cron/)" ]
    then
        echo "[+] found lsdminer crontab --> $(grep -Er "pastebin\.com\/raw\/........" /var/spool/cron/)" | tee -a $log_file
    fi

    echo "[+] end check lsdminer" >> $log_file
}

check_rainbowminer()
{
    echo "[+] start check rainbowminer" >> $log_file

    # 检测文件 /usr/bin/kthreadds
    if [ -f '/usr/bin/kthreadds' ]
    then
        if [ "$(cat /usr/bin/kthreadds)" != "botgank" ]
        then
            echo "[+] found rainbowminer file --> /usr/bin/kthreadds" | tee -a $log_file
        fi
    fi

    # 检测文件 /etc/init.d/pdflushs
    if [ -f '/etc/init.d/pdflushs' ]
    then
        if [ "$(cat /etc/init.d/pdflushs)" != "botgank" ]
        then
            echo "[+] found rainbowminer file --> /etc/init.d/pdflushs" | tee -a $log_file
        fi
    fi

    # 检测文件 /lib64/libgc++.so
    if [ -f '/lib64/libgc++.so' ]
    then
        if [ "$(cat /lib64/libgc++.so)" != "botgank" ]
        then
            echo "[+] found rainbowminer file --> /lib64/libgc++.so" | tee -a $log_file
        fi
    fi

    echo "[+] end check rainbowminer" >> $log_file
}

check_sysupdataminer()
{
    echo "[+] start check sysupdataminer" >> $log_file

    # 检测文件 /etc/sysupdate
    if [ -f '/etc/sysupdate' ]
    then
        if [ "$(cat /etc/sysupdate)" != "botgank" ]
        then
            echo "[+] found sysupdataminer file --> /etc/sysupdate" | tee -a $log_file
        fi
    fi

    # 检测文件 /etc/networkservice
    if [ -f '/etc/networkservice' ]
    then
        if [ "$(cat /etc/networkservice)" != "botgank" ]
        then
            echo "[+] found sysupdataminer file --> /etc/networkservice" | tee -a $log_file
        fi
    fi

    # 检测文件 /etc/networkservice
    if [ -f '/etc/update.sh' ]
    then
        if [ "$(cat /etc/update.sh)" != "botgank" ]
        then
            echo "[+] found sysupdataminer file --> /etc/update.sh" | tee -a $log_file
        fi
    fi

    echo "[+] end check sysupdataminer" >> $log_file
}

check_nginxminer()
{
    echo "[+] start check nginxminer" >> $log_file

    if [ -n "$(grep -Er '\/dev\/shm\/\.nginx' /var/spool/cron/)" ]
    then
        echo "[+] found nginxminer crontab --> $(grep -Er '\/dev\/shm\/\.nginx' /var/spool/cron/)" | tee -a $log_file
    fi

    if [ -d '/dev/shm/.nginx/' ]
    then
        echo "[+] found nginx dir --> /dev/shm/.nginx/" | tee -a $log_file
    fi

    echo "[+] end check nginxminer" >> $log_file
}

# --------------------------------------------------
# 主函数入口点

# 开始检测
echo "[+] start checking --> $(date)" | tee -a $log_file

check_ddg   # 检测DDG病毒

check_billgates # 检测BillGates病毒

check_systemminer   # 检测SystemMiner病毒

check_startminer    # 检测StartMiner病毒

check_xorddos   # 检测XorDDos病毒

check_lsdminer # 检测WatchdogMiner病毒

check_rainbowminer  # 检测RainbowMiner病毒

check_sysupdataminer  # 检测SysupdataMiner病毒

check_nginxminer    # 检测NginxMiner病毒

# 结束检测
echo "[+] end checking --> $(date)" | tee -a $log_file