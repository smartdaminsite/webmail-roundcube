#!/bin/sh

# Получаем идентификатор процесса
PROC_ID=`echo $$`

# Конфигурация RoundCube
echo "<?php " > /var/www/html/config/config.inc.php
echo "\$config = array(); " >> /var/www/html/config/config.inc.php
echo "\$config['db_dsnw'] = 'mysql://${RC_DB_USER}:${RC_DB_PASSWORD}@${RC_DB_HOST}/${RC_DB_NAME}'; " >> /var/www/html/config/config.inc.php
echo "\$config['default_host'] = '${MAIL_SERVER_HOST}'; " >> /var/www/html/config/config.inc.php
echo "\$config['smtp_server'] = '${MAIL_SERVER_HOST}'; " >> /var/www/html/config/config.inc.php
echo "\$config['smtp_port'] = 25; " >> /var/www/html/config/config.inc.php
echo "\$config['smtp_user'] = '%u'; " >> /var/www/html/config/config.inc.php
echo "\$config['smtp_pass'] = '%p'; ">> /var/www/html/config/config.inc.php
echo "\$config['support_url'] = ''; ">> /var/www/html/config/config.inc.php
echo "\$config['product_name'] = 'Roundcube Webmail'; " >> /var/www/html/config/config.inc.php
echo "\$config['des_key'] = 'rcmail-!24ByteDESkey*Str'; " >> /var/www/html/config/config.inc.php
echo "\$config['plugins'] = array( " >> /var/www/html/config/config.inc.php
echo "    'archive', " >> /var/www/html/config/config.inc.php
echo "    'zipdownload', " >> /var/www/html/config/config.inc.php
echo "); " >> /var/www/html/config/config.inc.php
echo "\$config['skin'] = 'larry'; " >> /var/www/html/config/config.inc.php

# Запускаем PHP-FPM и Nginx
/usr/sbin/nginx -g 'daemon off;' &
/usr/sbin/php-fpm7.3 -F &

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