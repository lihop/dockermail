#!/bin/bash

# start necessary services for operation (dovecot -F starts dovecot in the foreground to prevent container exit)
chown -R vmail:vmail /srv/vmail
service rsyslog start
service postfix start
dovecot -F
