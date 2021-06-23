#!/usr/bin/env bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
#
## Fix the vhosts folder and file perssions of the vhosts html directory
# set VHOST_FIX_PERMISSIONS to false to disable, enabled by default
# set VHOST_FIX_PERMISSIONS_FOLDERS to false to disable fixing folder permissions, enabled by default
# set VHOST_FIX_PERMISSIONS_FILES to false to disable fixing file permissions, enabled by default
# set VHOST_FIX_PERMISSIONS_FOLDERS_FORCE set to true to force folder fixing, disabled by default
# set VHOST_FIX_PERMISSIONS_FILES_FORCE set to true to force file fixing, disabled by default
# set VHOST_FIX_PERMISSIONS_FOLDERS_INTERVAL_HOURS set to X hours to only fix folders after X hours, default 24
# set VHOST_FIX_PERMISSIONS_FILE_INTERVAL_HOURS set to X hours to only fix files after X hours, default 24
#
#################################################################################

## enable case insensitve matching
shopt -s nocaseglob

XS_VHOST_DIR=${VHOST_DIR:-/var/www/vhosts}

XS_VHOST_FIX_PERMISSIONS=${VHOST_FIX_PERMISSIONS:-yes}
XS_VHOST_FIX_PERMISSIONS_FOLDERS=${VHOST_FIX_PERMISSIONS_FOLDERS:-yes}
XS_VHOST_FIX_PERMISSIONS_FILES=${VHOST_FIX_PERMISSIONS_FILE:-yes}

XS_VHOST_FIX_PERMISSIONS_FOLDERS_FORCE=${VHOST_FIX_PERMISSIONS_FOLDERS_FORCE:-no}
XS_VHOST_FIX_PERMISSIONS_FILES_FORCE=${VHOST_FIX_PERMISSIONS_FILES_FORCE:-no}

XS_VHOST_FIX_PERMISSIONS_FOLDERS_INTERVAL_HOURS=${VHOST_FIX_PERMISSIONS_FOLDERS_INTERVAL_HOURS:-24}
XS_VHOST_FIX_PERMISSIONS_FILES_INTERVAL_HOURS=${VHOST_FIX_PERMISSIONS_FILE_INTERVAL_HOURS:-24}


if [ "${XS_VHOST_FIX_PERMISSIONS,,}" == "yes" ] || [ "${XS_VHOST_FIX_PERMISSIONS,,}" == "true" ] || [ "${XS_VHOST_FIX_PERMISSIONS,,}" == "on" ] || [ "${XS_VHOST_FIX_PERMISSIONS}" == "1" ] ; then
  vhost_dir="$(realpath -s "${XS_VHOST_DIR}")"
  if [ -d "${vhost_dir}" ] ; then

    # get current system time since epoch
    current_time="$(date "+%s" 2> /dev/null)"
    current_time="${current_time//[^0-9]/}"
    current_time="$((current_time + 0))"

    ###### Fix vhost permissions : folders ######
    if [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS,,}" == "yes" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS,,}" == "true" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS,,}" == "on" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS}" == "1" ] ; then
      while IFS= read -r -d '' my_vhost_dir; do
        if [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS_FORCE,,}" == "yes" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS_FORCE,,}" == "true" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS_FORCE,,}" == "on" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FOLDERS_FORCE}" == "1" ] ; then
          last_permission_fix="0"
          time_check_interval="1"
        elif [ -r "${my_vhost_dir}/.fixed-folder-permissions" ] ; then
          last_permission_fix="$(cat "${my_vhost_dir}/.fixed-folder-permissions")"
          time_check_interval="${XS_VHOST_FIX_PERMISSIONS_FOLDERS_INTERVAL_HOURS//[^0-9]/}"
          time_check_interval="${time_check_interval:-1}"
          time_check_interval="$((time_check_interval * 3600 - 600))" # hous less 10mins
        else
          last_permission_fix="0"
          time_check_interval="1"
        fi
        time_interval="$((current_time - last_permission_fix))"
        if [ "$time_interval" -ge $((time_check_interval)) ] ; then
          echo "xshok-vhost-fix-permissions : fixing folder : ${my_vhost_dir}"
          if [ -d "${my_vhost_dir}/html" ] ; then
            find "${my_vhost_dir}/html" -type d -exec chown nobody:nogroup {} \;
            find "${my_vhost_dir}/html" -type d -exec chmod 0775 {} \;
          fi
          if [ -d "${my_vhost_dir}/certs" ] ; then
            chown -R nobody:nogroup "${my_vhost_dir}/certs"
            chmod -R 640 "${my_vhost_dir}/certs"
          fi
          echo "$current_time" > "${my_vhost_dir}/.fixed-folder-permissions"
          chown -f nobody:nogroup "${my_vhost_dir}/.fixed-folder-permissions"
        fi
      done < <(find "${vhost_dir}" -mindepth 1 -maxdepth 1 -type d -print0)  #dirs
    fi

    ###### Fix vhost permissions : files ######
    if [ "${XS_VHOST_FIX_PERMISSIONS_FILES,,}" == "yes" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FILES,,}" == "true" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FILES,,}" == "on" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FILES}" == "1" ] ; then
      while IFS= read -r -d '' my_vhost_dir; do
        if [ "${XS_VHOST_FIX_PERMISSIONS_FILES_FORCE,,}" == "yes" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FILES_FORCE,,}" == "true" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FILES_FORCE,,}" == "on" ] || [ "${XS_VHOST_FIX_PERMISSIONS_FILES_FORCE}" == "1" ] ; then
          last_permission_fix="0"
        elif [ -r "${my_vhost_dir}/.fixed-file-permissions" ] ; then
          last_permission_fix="$(cat "${my_vhost_dir}/.fixed-file-permissions")"
          time_check_interval="${XS_VHOST_FIX_PERMISSIONS_FILES_INTERVAL_HOURS//[^0-9]/}"
          time_check_interval="${time_check_interval:-1}"
          time_check_interval="$((time_check_interval * 3600 - 600))" # hous less 10mins
        else
          last_permission_fix="0"
        fi
        time_interval="$((current_time - last_permission_fix))"
        if [ "$time_interval" -ge $((time_check_interval)) ] ; then
          echo "xshok-vhost-fix-permissions : fixing files in : ${my_vhost_dir}"
          if [ -d "${my_vhost_dir}/html" ] ; then
            find "${my_vhost_dir}/html" -type f -exec chown nobody:nogroup {} \;
            find "${my_vhost_dir}/html" -type f -exec chmod 0664 {} \;
          fi
          echo "$current_time" > "${my_vhost_dir}/.fixed-file-permissions"
          chown -f nobody:nogroup "${my_vhost_dir}/.fixed-file-permissions"
        fi
      done < <(find "${vhost_dir}" -mindepth 1 -maxdepth 1 -type d -print0)  #dirs
    fi
  else
    echo "ERROR: xshok-vhost-fix-permissions : ${vhost_dir} is not a directory"
    exit 1
  fi
fi
