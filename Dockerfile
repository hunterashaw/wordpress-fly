FROM wordpress:php8.2-apache

ARG PORT
COPY wp-content/ /var/www/html/wp-content

RUN sed -i "s/Listen 80/Listen $PORT/" /etc/apache2/ports.conf 
RUN sed -i "s/:80/:$PORT/" /etc/apache2/sites-enabled/000-default.conf
