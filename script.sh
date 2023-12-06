#!/bin/bash
su - zimbra -c "zmcontrol stop"
certbot certonly -d zimbra.pauto.net.ru --standalone --preferred-chain  "ISRG Root X1" --agree-tos --register-unsafely-without-email --key-type rsa
chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt/
cp /etc/letsencrypt/live/mail.host.com-0001/* /opt/zimbra/ssl/letsencrypt
chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt/*
cp /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
chown zimbra:zimbra /opt/zimbra/ssl/zimbra/commercial/commercial.key
wget -O /tmp/ISRG-X1.pem https://letsencrypt.org/certs/isrgrootx1.pem.txt
#cat /opt/zimbra/ssl/letsencrypt/chain.pem
cat /tmp/ISRG-X1.pem >> /opt/zimbra/ssl/letsencrypt/chain.pem
#cat /opt/zimbra/ssl/letsencrypt/chain.pem
su - zimbra -c "/opt/zimbra/bin/zmcertmgr verifycrt comm /opt/zimbra/ssl/zimbra/commercial/commercial.key /opt/zimbra/ssl/letsencrypt/cert.pem /opt/zimbra/ssl/letsencrypt/chain.pem"
su - zimbra -c "/opt/zimbra/bin/zmcertmgr deploycrt comm /opt/zimbra/ssl/letsencrypt/cert.pem /opt/zimbra/ssl/letsencrypt/chain.pem"
su - zimbra -c "zmcontrol restart"
