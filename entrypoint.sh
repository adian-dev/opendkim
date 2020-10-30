#!/bin/sh

set -e

echo "127.0.0.1
localhost
0.0.0.0/0
*.${HOST? Error, HOST variable required}
${HOST}
" > /etc/opendkim/TrustedHosts

echo "mail._domainkey.${HOST} ${HOST}:mail:/etc/opendkim/keys/${HOST}.private" > /etc/opendkim/KeyTable

echo "*@${HOST} mail._domainkey.${HOST}" >/etc/opendkim/SigningTable 
echo "*.${HOST} mail._domainkey.${HOST}" >>/etc/opendkim/SigningTable 

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

