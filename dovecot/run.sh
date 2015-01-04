#!/bin/bash

# configure things
/configure.sh

# start necessary services for operation (dovecot -F starts dovecot in the foreground to prevent container exit)
chown -R vmail:vmail /srv/vmail


/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf