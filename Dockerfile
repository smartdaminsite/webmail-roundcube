FROM ubuntu:xenial

# Подключаем репозитарий и устанавливаем пакеты PHP-7.3
RUN apt-get update && apt-get -y install curl apt-transport-https ca-certificates && \
    apt-get -y install gnupg-agent software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && apt-get update &&\
    apt-get -y install php7.3 php7.3-cli php7.3-common php7.3-fpm php7.3-ldap && \
    apt-get -y install php7.3 php7.3-mbstring php7.3-xmlrpc php7.3-soap php7.3-bcmath && \
    apt-get -y install php7.3-gd php7.3-xml php7.3-intl php7.3-mysql php7.3-zip php7.3-curl php7.3-fpm &&\
    apt-get -y install php-mime-type php-mail-mime php7.3-imap

# Устанавливаем Nginx
RUN apt-get install -y nginx-full

# Пакеты для диагностики (в прод отключаем)
RUN apt-get install -y inetutils-ping dnsutils net-tools mc

# Конфигурация для WEB-приложения
RUN rm /var/www/html/index.nginx-debian.html
COPY ./nginx-app-config.conf /etc/nginx/sites-enabled/default

# Копируем Frontend RoundCube
COPY --chown=www-data:www-data ./roundcube/ /var/www/html/

# Определяем переменные для подключения к базе данных RoundCube
ENV RC_DB_USER "round_cube_user"
ENV RC_DB_PASSWORD "round_cube_password"
ENV RC_DB_NAME "round_cube"
ENV RC_DB_HOST "db_host"
ENV MAIL_SERVER_HOST "mail_host"
ENV SIEVE_HOST "sieve_host"
ENV SIEVE_PORT "sieve_port"

# Перенаправляем вывод логов в stdout и stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir /run/php/

# Создаем конфигурационные файлы и скрипт запуска согласно переменных окружения
COPY ./run.sh /opt/
RUN chmod +x /opt/run.sh

EXPOSE 8080
STOPSIGNAL SIGTERM

CMD /opt/run.sh
