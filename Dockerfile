FROM php:5.6-cli
MAINTAINER koolob
ENV WORK_HOME /home/swoole
RUN mkdir -p ${WORK_HOME}
RUN apt-get update && apt-get install -y \
	wget \
	zip \
	libssl-dev
RUN cd ${WORK_HOME} \
	&& wget https://github.com/redis/hiredis/archive/v0.13.3.zip \
	&& unzip v0.13.3.zip \
	&& cd hiredis-0.13.3 \
	&& make -j \
	&& make install \
	&& ldconfig

RUN cd ${WORK_HOME} \
	&& wget https://pecl.php.net/get/swoole-1.8.3.tgz \
	&& tar zxvf swoole-1.8.3.tgz \
	&& cd swoole-1.8.3 \
	&& phpize \
	&& ./configure --enable-async-redis --enable-async-httpclient --enable-openssl \
	&& make \
	&& make install

RUN pecl install redis \
	&& docker-php-ext-enable redis \
	&& docker-php-ext-enable swoole