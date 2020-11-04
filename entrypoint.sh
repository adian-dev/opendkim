#!/bin/sh

set -e

echo "127.0.0.1
localhost
0.0.0.0/0
*.${HOST? Error, HOST variable required}
${HOST}
" > /etc/opendkim/TrustedHosts

SELECTOR=${SELECTOR-mail}

echo "${SELECTOR}._domainkey.${HOST} ${HOST}:${SELECTOR}:/etc/opendkim/keys/${HOST}.private" > /etc/opendkim/KeyTable

echo "*@${HOST} ${SELECTOR}._domainkey.${HOST}" >/etc/opendkim/SigningTable 
echo "*.${HOST} ${SELECTOR}._domainkey.${HOST}" >>/etc/opendkim/SigningTable 

if [ -f "/etc/opendkim/keys/${HOST}.txt" ]
then
	echo "Keys already exists"
else
	echo "Keys not exist, generating..."
	cd /etc/opendkim/keys/
	opendkim-genkey -s ${HOST}
	chown opendkim:opendkim ${HOST}.private
	chmod 600 ${HOST}.private
	cat ${HOST}.txt | tr '\n' ' '
	cd
fi

service rsyslog start

opendkim -f

