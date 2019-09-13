#!/bin/sh

docker build -t smartdminsite/webmail-roundcube:latest .
docker run -p 127.0.0.1:9090:8080 -it --name webmail-roundcube-test smartdminsite/webmail-roundcube:latest bash
docker rm webmail-roundcube-test