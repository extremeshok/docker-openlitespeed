#!/usr/bin/env bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
#
## Fix the vhosts folder and file perssions of the vhosts html directory
# set VHOST_FIX_PERMISSIONS to false to disable, enabled by default
# set XS_VHOST_FIX_PERMISSIONS_FOLDERS to false to disable fixing folder permissions, enabled by default
# set XS_VHOST_FIX_PERMISSIONS_FILES to false to disable fixing file permissions, enabled by default
# set XS_VHOST_FIX_PERMISSIONS_FOLDERS to false to disable, enabled by default
#
#################################################################################

## enable case insensitve matching
shopt -s nocaseglob

XS_VHOST_DIR=${VHOST_DIR:-/var/www/vhosts}

XS_VHOST_FIX_PERMISSIONS=${VHOST_FIX_PERMISSIONS:-yes}
XS_VHOST_FIX_PERMISSIONS_FOLDERS=${VHOST_FIX_PERMISSIONS_FOLDERS:-yes}
XS_VHOST_FIX_PERMISSIONS_FILES=${VHOST_FIX_PERMISSIONS_FILE:-yes}

if [ "${XS_VHOST_FIX_PERMISSIONS}" == "yes" ] || [ "${XS_VHOST_FIX_PERMISSIONS}" == "true" ] || [ "${XS_VHOST_FIX_PERMISSIONS}" == "on" ] || [ "${XS_VHOST_FIX_PERMISSIONS}" == "1" ] ; then
  vhost_dir="$(realpath -s "${XS_VHOST_DIR}")"
  if [ -d "${vhost_dir}" ] ; then
    ###### Fix vhost permissions : folders ######
    if [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS}" == "yes" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS}" == "true" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS}" == "on" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS}" == "1" ] ; then
      while IFS= read -r -d '' my_vhost_dir; do
        echo "Fixing vhost folder permissions : ${my_vhost_dir}"
        if [ -d "${my_vhost_dir}/html" ] ; then
          find "${my_vhost_dir}/html" -type d -exec chown nobody:nogroup {} \;
          find "${my_vhost_dir}/html" -type d -exec chmod 0775 {} \;
        fi
        if [ -d "${my_vhost_dir}/certs" ] ; then
          chown -R nobody:nogroup "${my_vhost_dir}/certs"
          chmod -R 640 "${my_vhost_dir}/certs"
        fi
      done < <(find "${vhost_dir}" -mindepth 1 -maxdepth 1 -type d -print0)  #dirs
    fi

    ###### Fix vhost permissions : files ######
    if [ "${XS_VHOST_FIX_PERMISSIONS_FILES}" == "yes" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FILES}" == "true" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FILES}" == "on" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FILES}" == "1" ] ; then
      while IFS= read -r -d '' my_vhost_dir; do
        echo "Fixing vhostfile permissions : ${my_vhost_dir}"
        if [ -d "${my_vhost_dir}/html" ] ; then
          find "${my_vhost_dir}/html" -type f -exec chown nobody:nogroup {} \;
          find "${my_vhost_dir}/html" -type f -exec chmod 0664 {} \;
        fi
      done < <(find "${vhost_dir}" -mindepth 1 -maxdepth 1 -type d -print0)  #dirs
    fi
  else
    echo "ERROR: ${vhost_dir} is not a directory"
  fi
fi
