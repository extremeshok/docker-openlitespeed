#!/usr/bin/env bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
#
# Generate cron.d files from cron files located in the vhost/vhost_name/cron dirs
#
# Set VHOST_CRON to "no" to disable
#
#################################################################################

## enable case insensitve matching
shopt -s nocaseglob

XS_VHOST_DIR=${VHOST_DIR:-/var/www/vhosts}

TMP_CRON_DIR="/tmp/xs_cron"
CRON_DIR="/etc/cron.d"

# automatic cron generation
# add legacy support for old varible
XS_VHOST_CRON=${VHOST_CRON_ENABLE:-no}
XS_VHOST_CRON=${VHOST_CRON:-no}

##### Generate vhost cron on start
if [ "${XS_VHOST_CRON}" == "yes" ] || [ "${XS_VHOST_CRON}" == "true" ] || [ "${XS_VHOST_CRON}" == "on" ] || [ "${XS_VHOST_CRON}" == "1" ] ; then
    if [ ! -f "/etc/cron.hourly/generate-vhost-cron" ] ; then
        echo "#!/usr/bin/env bash" > /etc/cron.hourly/generate-vhost-cron
        echo "bash /xshok-vhost-generate-cron.sh" >> /etc/cron.hourly/generate-vhost-cron
        chmod +x /etc/cron.hourly/generate-vhost-cron
    fi
    vhost_dir="$(realpath -s "${XS_VHOST_DIR}")"
    if [ -d "${vhost_dir}" ] ; then
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
        done < <(find "${vhost_dir}" -mindepth 1 -maxdepth 1 -type d -print0)  #dirs
        echo ""
    else
        echo "ERROR: ${vhost_dir} is not a directory"
    fi

    # rsync only if there are files
    if [ -n "$(ls -A "${TMP_CRON_DIR}")" ]; then
        echo "Syncing generated files to ${CRON_DIR}"
        rsync --dirs -v --checksum --delete --remove-source-files "${TMP_CRON_DIR}/" "${CRON_DIR}/"
    fi
else
    rm -f "/etc/cron.hourly/generate-vhost-cron"
fi
