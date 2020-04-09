FROM extremeshok/baseimage-ubuntu AS BUILD
LABEL mantainer="Adrian Kriel <admin@extremeshok.com>" vendor="eXtremeSHOK.com"

USER root

RUN echo "**** Install packages ****" \
  && apt-install gnupg gnupg-utils netcat less

RUN echo "**** Add OpenLiteSpeed Repo ****" \
  && wget https://rpms.litespeedtech.com/debian/lst_repo.gpg -O /usr/local/src/lst_repo.gpg \
  && apt-key add /usr/local/src/lst_repo.gpg \
  && CODENAME=$(grep 'VERSION_CODENAME=' /etc/os-release | cut -d"=" -f2 | xargs) \
  && echo "deb http://rpms.litespeedtech.com/debian/ ${CODENAME} main" >> /etc/apt/sources.list

RUN echo "**** Install OpenLiteSpeed  ****" \
  && apt-install openlitespeed ols-modsecurity ols-pagespeed

# BUG: lsphp73 is marked as a dependancy.. we will ignore this... a bug has been filed : https://github.com/litespeedtech/openlitespeed/issues/170

RUN echo "**** Create symbolic links ****" \
  && rm -rf /etc/openlitespeed \
  && ln -s /usr/local/lsws/conf/ /etc/openlitespeed \
  && ln -s /usr/local/lsws/admin/conf/ /etc/openlitespeed/admin

# Update ca-certificates
RUN echo "**** Update ca-certificates ****" \
  && update-ca-certificates

RUN echo "*** house keeping ***" \
  && DEBIAN_FRONTEND=noninteractive \
  && apt-get -y autoremove \
  && apt-get -y autoclean \
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/*

RUN echo "*** Configure logging ***" \
  && ln -sf /dev/stdout /usr/local/lsws/logs/access.log \
  && ln -sf /dev/stderr /usr/local/lsws/logs/error.log

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN echo "**** Fix permissions ****" \
  && mkdir -p /var/www/vhosts/localhost/html \
  && mkdir -p /var/www/vhosts/localhost/logs \
  && mkdir -p /var/www/vhosts/localhost/certs \
  && chown -R nobody:nogroup /var/www/vhosts/

COPY rootfs/ /

RUN echo "*** Backup OpenLiteSpeed Configs ***" \
  && mkdir -p  /usr/local/lsws/default-config/admin \
  && cp -rf  /usr/local/lsws/conf/* /usr/local/lsws/default-config \
  && cp -rf  /usr/local/lsws/admin/conf/* /usr/local/lsws/default-config/admin

WORKDIR /var/www/vhosts/localhost/

EXPOSE 80 443 443/udp 7080

# "when the SIGTERM signal is sent, it immediately quits and all established connections are closed"
# "graceful stop is triggered when the SIGUSR1 signal is sent "
STOPSIGNAL SIGUSR1

HEALTHCHECK --interval=5s --timeout=5s CMD [ "301" = "$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:7080/)" ] || exit 1

ENTRYPOINT ["/init"]
