#!/bin/bash

# postfix configuration
echo $MAILNAME > /etc/mailname
cat /etc/postfix/master-additional.cf >> /etc/postfix/master.cf

# configure mail delivery to dovecot
cp /mailbase/aliases /etc/postfix/virtual
cp /mailbase/domains /etc/postfix/virtual-mailbox-domains

# todo: this could probably be done in one line
mkdir /etc/postfix/tmp; awk < /etc/postfix/virtual '{ print $2 }' > /etc/postfix/tmp/virtual-receivers
sed -r 's,(.+)@(.+),\2/\1/,' /etc/postfix/tmp/virtual-receivers > /etc/postfix/tmp/virtual-receiver-folders
paste /etc/postfix/tmp/virtual-receivers /etc/postfix/tmp/virtual-receiver-folders > /etc/postfix/virtual-mailbox-maps

# map virtual aliases and user/filesystem mappings
postmap /etc/postfix/virtual
postmap /etc/postfix/virtual-mailbox-maps

# add user vmail who own all mail folders
groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /srv/vmail -m
chown -R vmail:vmail /srv/vmail
chmod u+w /srv/vmail

# Add password file
cp /mailbase/passwords /etc/dovecot/passwd
