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
echo "    'managesieve', " >> /var/www/html/config/config.inc.php
echo "); " >> /var/www/html/config/config.inc.php
echo "\$config['skin'] = 'larry'; " >> /var/www/html/config/config.inc.php

# Конфигурация плагина SIEVE
echo "<?php"  > /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_port'] = $SIEVE_PORT;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_host'] = '$SIEVE_HOST';"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_auth_type'] = null;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_auth_cid'] = null;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_auth_pw'] = null;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_usetls'] = false;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_conn_options'] = null;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_default'] = '/etc/dovecot/sieve/global';"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_script_name'] = 'managesieve';"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_mbox_encoding'] = 'UTF-8';"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_replace_delimiter'] = '';"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_disabled_extensions'] = array();"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_debug'] = false;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_kolab_master'] = false;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_filename_extension'] = '.sieve';"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_filename_exceptions'] = array();"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_domains'] = array();"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_vacation'] = 0;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_vacation_interval'] = 0;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_vacation_addresses_init'] = false;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_vacation_from_init'] = false;"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_notify_methods'] = array('mailto');"  >> /var/www/html/plugins/managesieve/config.inc.php
echo "$config['managesieve_raw_editor'] = true;"  >> /var/www/html/plugins/managesieve/config.inc.php

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
        done
    sleep 5
    done;

exit 0