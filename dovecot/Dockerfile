FROM ubuntu:14.04 

# prerequisites
RUN apt-get update

# install self-signed ssl certs
RUN apt-get install -y --force-yes ssl-cert

# Install postfix as MTA
RUN apt-get install -y --force-yes postfix

# Install dovecot as IMAP server
RUN apt-get install -y --force-yes dovecot-imapd

# postfix configuration
ADD ./postfix.main.cf /etc/postfix/main.cf
ADD ./postfix.master.cf.append /etc/postfix/master-additional.cf

# dovecot configuration
ADD ./dovecot.mail /etc/dovecot/conf.d/10-mail.conf
ADD ./dovecot.ssl /etc/dovecot/conf.d/10-ssl.conf
ADD ./dovecot.auth /etc/dovecot/conf.d/10-auth.conf
ADD ./dovecot.master /etc/dovecot/conf.d/10-master.conf
ADD ./dovecot.lda /etc/dovecot/conf.d/15-lda.conf
ADD ./dovecot.imap /etc/dovecot/conf.d/20-imap.conf
# add verbose logging
#ADD ./internal/dovecot.logging /etc/dovecot/conf.d/10-logging.conf

# i'm not sure what expose actually does, so its mainly here for documentation
# smtp port for incoming mail
EXPOSE 25 
# imap port
EXPOSE 143
# smtp port for outgoing
EXPOSE 587

# todo: enable port 587 for outgoing mail, separate ports 25 and 587
# http://www.synology-wiki.de/index.php/Zusaetzliche_Ports_fuer_Postfix

# add script to configure container
ADD ./configure.sh /configure.sh
RUN chmod 755 /configure.sh

# add script to run at container start
ADD ./run.sh /run.sh
RUN chmod 755 /run.sh

ENV MAILNAME mail.docker.container
ENV CERTIFICATE dovecot.pem
ENV KEYFILE dovecot.pem

# start necessary services for operation
CMD ["/run.sh"]
