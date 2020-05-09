#!/usr/bin/env bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
#
# Generate cron.d files from cron files located in the vhost/vhost_name/cron dirs
#
# Set VHOST_CRON_ENABLE to "no" to disable
#
#################################################################################

VHOST_DIR="/var/www/vhosts"
TMP_CRON_DIR="/tmp/xs_cron"
CRON_DIR="/etc/cron.d"

if [ -d "${VHOST_DIR}" ] ; then
  echo "Generating cron files"
  rm -rf "${TMP_CRON_DIR}"
  mkdir -p "${TMP_CRON_DIR}"

  while IFS= read -r -d '' my_vhost_dir; do
    vhost="${my_vhost_dir##*/}"
    if [ -d "${my_vhost_dir}/cron" ] ; then
      echo "Found cron dir for ${vhost}"
      while IFS= read -r -d '' cron_file ; do
        cron_file_name=${cron_file##*/}
        filtered_cron_file_name=${cron_file_name//\./_}
        filtered_vhost=${vhost//\./_}

        echo "Found: ${cron_file} in ${vhost} "
        cp -f "${cron_file}" "${TMP_CRON_DIR}/${filtered_vhost}-${filtered_cron_file_name}"
        chmod 0644 "${TMP_CRON_DIR}/${filtered_vhost}-${filtered_cron_file_name}"

        echo "Generated: ${filtered_vhost}-${filtered_cron_file_name}"

      done < <(find "${my_vhost_dir}/cron" -mindepth 1 -maxdepth 1 -type f -print0)  #files
    fi
  done < <(find "${VHOST_DIR}" -mindepth 1 -maxdepth 1 -type d -print0)  #dirs
  echo ""
fi

# rsync only if there are files
if [ -n "$(ls -A "${TMP_CRON_DIR}")" ]; then
  echo "Syncing generated files to ${CRON_DIR}"
  rsync --dirs -v --checksum --delete --remove-source-files "${TMP_CRON_DIR}/" "${CRON_DIR}/"
fi
