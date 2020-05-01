FROM extremeshok/baseimage-ubuntu AS BUILD
LABEL mantainer="Adrian Kriel <admin@extremeshok.com>" vendor="eXtremeSHOK.com"
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################

USER root

RUN echo "**** Install packages ****" \
  && apt-install gnupg gnupg-utils netcat less git inotify-tools rsync

RUN echo "**** Add OpenLiteSpeed Repo ****" \
  && wget https://rpms.litespeedtech.com/debian/lst_repo.gpg -O /usr/local/src/lst_repo.gpg \
  && apt-key add /usr/local/src/lst_repo.gpg \
  && echo "deb http://rpms.litespeedtech.com/debian/ $(grep 'VERSION_CODENAME=' /etc/os-release | cut -d"=" -f2 | xargs) main" >> /etc/apt/sources.list

RUN echo "**** Install OpenLiteSpeed  ****" \
  && apt-install openlitespeed ols-modsecurity ols-pagespeed

# BUG: lsphp73 is marked as a dependancy.. we will ignore this... a bug has been filed : https://github.com/litespeedtech/openlitespeed/issues/170

RUN echo "**** Install and configure modsecurity owasp  ****" \
  && mkdir -p /usr/local/lsws/conf/modsecurity \
  && cd /usr/local/lsws/conf/modsecurity \
  && git clone --recursive --depth=1 https://github.com/SpiderLabs/owasp-modsecurity-crs.git \
  && mv -f /usr/local/lsws/conf/modsecurity/owasp-modsecurity-crs/crs-setup.conf.example /usr/local/lsws/conf/modsecurity/owasp-modsecurity-crs/crs-setup.conf \
  && mv -f /usr/local/lsws/conf/modsecurity/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/local/lsws/conf/modsecurity/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf \
  && mv -f /usr/local/lsws/conf/modsecurity/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example /usr/local/lsws/conf/modsecurity/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf

# Update ca-certificates
RUN echo "**** Update ca-certificates ****" \
  && update-ca-certificates

RUN echo "*** house keeping ***" \
  && DEBIAN_FRONTEND=noninteractive \
  && apt-get -y autoremove \
  && apt-get -y autoclean \
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/*

RUN echo "*** Ensure log files exist ***" \
  && touch /usr/local/lsws/logs/access.log \
  && touch /usr/local/lsws/logs/modsec.log \
  && touch /usr/local/lsws/logs/lsrestart.log \
  && touch /usr/local/lsws/logs/error.log

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN echo "**** Fix permissions ****" \
  && mkdir -p /var/www/vhosts/localhost/html \
  && mkdir -p /var/www/vhosts/localhost/logs \
  && mkdir -p /var/www/vhosts/localhost/certs \
  && mkdir -p /var/www/vhosts/localhost/cron \
  && chown -R nobody:nogroup /var/www/vhosts/

COPY rootfs/ /

RUN echo "*** Backup OpenLiteSpeed Configs ***" \
  && mkdir -p  /usr/local/lsws/default/admin \
  && mkdir -p  /usr/local/lsws/default/conf \
  && mkdir -p  /usr/local/lsws/default/localhost \
  && cp -rf  /usr/local/lsws/conf/* /usr/local/lsws/default/conf \
  && cp -rf  /usr/local/lsws/admin/conf/* /usr/local/lsws/default/admin \
  && cp -rf  /var/www/vhosts/localhost/* /usr/local/lsws/default/localhost

RUN echo "**** Create symbolic links ****" \
  && rm -rf /etc/openlitespeed \
  && rm -rf  /usr/local/lsws/conf \
  && rm -rf  /usr/local/lsws/admin/conf \
  && mkdir -p /etc/openlitespeed/conf \
  && mkdir -p /etc/openlitespeed/admin \
  && ln -s /etc/openlitespeed/conf /usr/local/lsws/conf \
  && ln -s /etc/openlitespeed/admin /usr/local/lsws/admin/conf

RUN echo "**** Correct permissions ****" \
  && chown -R lsadm:lsadm /usr/local/lsws \
  && chown -R nobody:nogroup /usr/local/lsws/logs/ \
  && chmod +x /etc/services.d/cron/run \
  && chmod +x /etc/services.d/inotify-certs/run \
  && chmod +x /etc/services.d/openlitespeed/run \
  && chmod +x /etc/services.d/tail-log-error/run


RUN echo "**** Ensure there is no admin password ****" \
  && rm -f /etc/openlitespeed/admin/htpasswd

WORKDIR /var/www/vhosts/localhost/

EXPOSE 80 443 443/udp 7080 8088

# "when the SIGTERM signal is sent, it immediately quits and all established connections are closed"
# "graceful stop is triggered when the SIGUSR1 signal is sent "
STOPSIGNAL SIGUSR1

HEALTHCHECK --interval=5s --timeout=5s CMD [ "301" = "$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:7080/)" ] || exit 1

ENTRYPOINT ["/init"]
