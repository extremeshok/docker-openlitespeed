#!/bin/bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
## enable case insensitve matching
shopt -s nocaseglob

######  Generate crontab ######
# busybox only allows for a single cron, all cron will be run as the nobody user
if [ ! -f "/etc/cron.d/*" ] ; then
  echo "Generating single crontab from cronjobs in /etc/cron.d/"
  cat /etc/cron.d/* | crontab -u nobody -
fi

###### LAUNCH LITESPEEED SERVER ######
/usr/local/lsws/bin/lswsctrl start
while true; do
  if ! /usr/local/lsws/bin/lswsctrl status | grep -q "litespeed is running with PID" ; then
    break
  fi
  sleep 60
done
