#!/usr/bin/env bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
#
# Restart openlitespeed when changes to the vhost/*/cert dirs are detected
# when a chnage is detected, it will restart openlitespeed after waiting for 300seconds
# requires watchmedo which is provided by python3-watchdog
#
#################################################################################

## enable case insensitve matching
shopt -s nocaseglob

XS_VHOST_DIR=${VHOST_DIR:-/var/www/vhosts}

XS_VHOST_MONITOR_CERTS=${VHOST_MONITOR_CERTS:-yes}

if [ "${XS_VHOST_MONITOR_CERTS,,}" == "yes" ] || [ "${XS_VHOST_MONITOR_CERTS,,}" == "true" ] || [ "${XS_VHOST_MONITOR_CERTS,,}" == "on" ] || [ "${XS_VHOST_MONITOR_CERTS}" == "1" ] ; then
    vhost_dir="$(realpath -s "${XS_VHOST_DIR}")"
    if [ -d "${vhost_dir}" ] ; then
      while ! /usr/local/lsws/bin/lswsctrl status | grep -q "litespeed is running with PID" ; do
      	echo "Waiting for OpenLiteSpeed to start"
        sleep 30s
      done

      while true ; do
        #watchmedo shell-command --ignore-patterns="${vhost_dir}/*/acme/*;${vhost_dir}/*/dbinfo/*;${vhost_dir}/*/html/*;${vhost_dir}/*/logs/*;${vhost_dir}/*/sql/*;${vhost_dir}/*/logs/*;${vhost_dir}/*/backup/*;" --patterns="${vhost_dir}/*/certs/*.pem" --ignore-directories --recursive --wait --drop --timeout 30 /var/www/vhosts --command='echo "${watch_src_path} - ${watch_dest_path} - ${watch_event_type} - ${watch_object}"'
        watchmedo shell-command --ignore-patterns="${vhost_dir}/local.domain/*;${vhost_dir}/local/*;${vhost_dir}/localhost/*;${vhost_dir}/localdomain/*;${vhost_dir}/sample/*;${vhost_dir}/example/*;${vhost_dir}/*/acme/*;${vhost_dir}/*/dbinfo/*;${vhost_dir}/*/html/*;${vhost_dir}/*/logs/*;${vhost_dir}/*/sql/*;${vhost_dir}/*/logs/*;${vhost_dir}/*/backup/*;" --patterns="${vhost_dir}/*/certs/*.pem" --ignore-directories --recursive --wait --drop --timeout 300 "${vhost_dir}" --command='echo "${watch_src_path} : ${watch_event_type}, sleeping for 300s" && sleep 300 && echo "restarting litespeed" && /usr/local/lsws/bin/lswsctrl restart'
        echo "watchmedo quit, sleeping for 60s and then reloading"
        sleep 60s
      done
    else
    echo "ERROR: ${vhost_dir} is not a directory"
  fi
fi
