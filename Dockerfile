FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractiv

RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install  -y rsyslog opendkim opendkim-tools openssl && \
	sed -i 's/\/var\/log\/mail/\/var\/log\/dkim\/mail/' /etc/rsyslog.conf

RUN mkdir -p /etc/opendkim

RUN mkdir -p /etc/opendkim/keys

COPY opendkim.conf /etc/opendkim.conf
COPY entrypoint.sh .

VOLUME /etc/opendkim/keys
VOLUME /var/log/dkim

EXPOSE 8892

ENTRYPOINT ./entrypoint.sh

