#!/bin/bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
## enable case insensitve matching
shopt -s nocaseglob

######  Initialize Configs ######
# Restore configs if they are missing, ie if a new/empty volume was used to store the configs
if [ ! -f  "/etc/openlitespeed/conf/httpd_config.conf" ] || [ ! -f  "/etc/openlitespeed/admin/admin_config.conf" ] ; then
  cp -rf /usr/local/lsws/default/conf/* /etc/openlitespeed/conf/
  cp -rf /usr/local/lsws/default/admin/* /etc/openlitespeed/admin/
  chown -R lsadm:lsadm /etc/openlitespeed
fi

# generate a random admin password, if one is not defined
if [ ! -f  "/etc/openlitespeed/admin/htpasswd" ] ; then
  echo "admin: $(/usr/local/lsws/admin/fcgi-bin/admin_php* -q /usr/local/lsws/admin/misc/htpasswd.php '$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)') " > /etc/openlitespeed/admin/htpasswd
  chmod 644 /etc/openlitespeed/admin/htpasswd
fi

# Restore localhost if missing, ie if a new/empty volume was used to store the www/vhost
if [ ! -d  "/var/www/vhosts/localhost/" ] ; then
  mkdir -p /var/www/vhosts/localhost/
  cp -rf /usr/local/lsws/default/localhost/* /var/www/vhosts/localhost/
fi

if [ ! -f  "/var/www/vhosts/localhost/certs/privkey.pem" ] || [ ! -f  "/var/www/vhosts/localhost/certs/fullchain.pem" ] ; then
  echo "Generating default certificate and key for localhost"
  openssl req -new -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -out /var/www/vhosts/localhost/certs/fullchain.pem -keyout  /var/www/vhosts/localhost/certs/privkey.pem -subj "/C=RO/ST=Bucharest/L=Bucharest/O=IT/CN=localhost"
fi

###### Fix vhost permissions ######
if [ -d "/var/www/vhosts" ] ; then
  while IFS= read -r -d '' my_vhost_dir; do
    echo "Fixing vhost permissions"
    if [ -d "${my_vhost_dir}/html" ] ; then
      find "${my_vhost_dir}/html" -type f -exec chmod 0664 {} \;
      find "${my_vhost_dir}/html" -type d -exec chmod 0775 {} \;
    fi
    if [ -d "${my_vhost_dir}/certs" ] ; then
      chown -R nobody:nogroup "${my_vhost_dir}/certs"
      chmod -R 640 "${my_vhost_dir}/certs"
    fi
  done < <(find "${VHOST_DIR}" -mindepth 1 -maxdepth 1 -type d -print0)  #dirs
fi

##### Generate vhost cron on start
echo "xshok-init-post.sh" >> /tmp/testing
bash /xshok-generate-vhost-cron.sh

###### LAUNCH LITESPEEED SERVER ######
/usr/local/lsws/bin/lswsctrl start
while true; do
  if ! /usr/local/lsws/bin/lswsctrl status | grep -q "litespeed is running with PID" ; then
    break
  fi
  sleep 60
done
