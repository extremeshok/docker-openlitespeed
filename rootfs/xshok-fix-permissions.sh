#!/bin/bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
## enable case insensitve matching
shopt -s nocaseglob

###### Fix vhost permissions : folders ######
if [ -d "/var/www/vhosts" ] ; then

  while IFS= read -r -d '' my_vhost_dir; do
    echo "Fixing vhost permissions : folders"
    if [ -d "${my_vhost_dir}/html" ] ; then
      find "${my_vhost_dir}/html" -type d -exec chmod 0775 {} \;
    fi
    if [ -d "${my_vhost_dir}/certs" ] ; then
      chown -R nobody:nogroup "${my_vhost_dir}/certs"
      chmod -R 640 "${my_vhost_dir}/certs"
    fi
  done < <(find "/var/www/vhosts" -mindepth 1 -maxdepth 1 -type d -print0)  #dirs
fi

###### Fix vhost permissions : files ######
if [ -d "/var/www/vhosts" ] ; then

  while IFS= read -r -d '' my_vhost_dir; do
    echo "Fixing vhost permissions : files"
    if [ -d "${my_vhost_dir}/html" ] ; then
      find "${my_vhost_dir}/html" -type f -exec chmod 0664 {} \;
    fi
  done < <(find "/var/www/vhosts" -mindepth 1 -maxdepth 1 -type d -print0)  #dirs
fi
