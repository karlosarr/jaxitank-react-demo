FROM nginx:1.17.9
LABEL maintainer="Carlos Ruiz <cruizr@cinepolis.com>"
COPY conf/nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/share/nginx/html
COPY html/ .
