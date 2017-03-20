FROM python:3.5-alpine

MAINTAINER "Roy Castro"
LABEL project="docker-nginx-uwsgi-django"
LABEL version = "0.0.1"
LABEL author="Roy Castro"
LABEL author_email="rcastro9007@gmail.com"
RUN adduser -S sshuser
RUN echo "root:root" | chpasswd
RUN echo "sshuser:root" | chpasswd
RUN apk add --update \
    openssh \
    nginx \
    supervisor \ 
    python-dev \
    build-base \
    linux-headers \
    pcre-dev \
    py-pip \ 
    vim \
  && rm -rf /var/cache/apk/* && \
  chown -R nginx:www-data /var/lib/nginx

RUN pip install https://github.com/unbit/uwsgi/archive/uwsgi-2.0.zip#egg=uwsgi

ADD . /app
WORKDIR /app

RUN pip install django

RUN mkdir /etc/nginx/sites-enabled
RUN rm /etc/nginx/nginx.conf
RUN ln -s /app/nginx/nginx.conf /etc/nginx/
RUN ln -s /app/nginx/nginx-app.conf /etc/nginx/sites-enabled/
RUN rm /etc/supervisord.conf
RUN ln -s /app/supervisord/supervisord.conf /etc/

EXPOSE [80,5492,22]

CMD ["supervisord", "-n"]
