#!/bin/sh

# Получаем идентификатор процесса
PROC_ID=`echo $$`

# Конфигурация RoundCube

# Отслеживаем состояние процессов
WATCH_FOR="nginx,php-fpm"
sleep 10

while true;
    do
    echo $WATCH_FOR | tr "," "\n" | while read _proc;
        do
        proc_count=`ps ax | grep "${_proc}" | grep -v "grep" | wc -l`
        #echo "Watch for ${_proc} - ${proc_count}"
        if [ "${proc_count}" = "0" ];
        then
                echo "Proc ${_proc} is down - EXIT NOW!"
                kill -9 $PROC_ID
        fi
        echo $LOGOUT
        done
    sleep 5
    done;

exit 0