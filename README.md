# eXtremeSHOK.com Docker OpenLiteSpeed with modsecurity and pagespeed on Ubuntu LTS

## Uses the base image extremeshok/baseimage-ubuntu : https://hub.docker.com/r/extremeshok/baseimage-ubuntu

## Need PHP ? extremeshok/openlitespeed-php : https://hub.docker.com/repository/docker/extremeshok/openlitespeed-php

## Checkout our optimized production web-server setup based on docker https://github.com/extremeshok/docker-webserver

## Note all configs are optimized and designed for production usage

* Ubuntu LTS with S6
* Will detect and apply new ssl certs automatically (WATCHMEDO_CERTS_ENABLE)
* cron (/etc/cron.d) enabled for scheduling tasks, run as user nobody
* cron runs every 1 minute, and will generate a new vhost cron every 15mins *if vhost_cron is enabled*
* Preinstalled IP2Location DB , updated monthly on start (IP2LOCATION-LITE-DB1.IPV6.BIN from https://lite.ip2location.com)
* IP2Location running in Shared Memory DB Cache
* Optimized OpenLiteSpeed configs
* Optimised HTTP Headers for Security (Content Security Policy (CSP), Access-Control-Allow-Methods, Content-Security-Policy, Strict-Transport-Security, X-Content-Type-Options, X-DNS-Prefetch-Control, X-Frame-Options, X-XSS-Protection)
* OpenLiteSpeed installed via github releases (always newer than the repo)
* OpenLiteSpeed Repository used for lsphp
* IONICE set to -10
* Low memory usage
* HEALTHCHECK activated
* Graceful shutdown
* tail modsec.log and error.log to stdout
* configs located in /etc/openlitespeed/
* default configs will be added if the config dir is empty
* OWASP modsecurity rules enabled
* Restart openlitespeed when changes to the vhost/domain.com/cert dirs are detected, ie ssl certificate is updated
* xshok-vhost-fix-permissions, xshok-vhost-generate-cron and xshok-vhost-monitor-certs are all non-blocking (runs parallel)
* Outputs platform information on start

# VHOST_FIX_PERMISSIONS (enabled by default)
## Fix the vhosts folder and file permissions of the vhosts html directory
## will only run once per 24hours in default settings
* set VHOST_FIX_PERMISSIONS to false to disable, enabled by default
* set VHOST_FIX_PERMISSIONS_FOLDERS to false to disable fixing folder permissions, enabled by default
* set VHOST_FIX_PERMISSIONS_FILES to false to disable fixing file permissions, enabled by default
* set VHOST_FIX_PERMISSIONS_FOLDERS_FORCE set to true to force folder fixing, disabled by default
* set VHOST_FIX_PERMISSIONS_FILES_FORCE set to true to force file fixing, disabled by default
* set VHOST_FIX_PERMISSIONS_FOLDERS_INTERVAL_DAYS set to X hours to only fix folders after X days, default 7
* set VHOST_FIX_PERMISSIONS_FILE_INTERVAL_DAYS set to X hours to only fix files after X days, default 7


# VHOST_CRON (disabled by default)
## generate cron from cron files located in vhost/cron (hourly)
* set VHOST_CRON to true to enable, disabled by default
* finds all vhost/cron files and places them in the /etc/cron.d/ , runs hourly
* ignores  *.readme *.disabled *.disable *.txt *.sample files
* cron runs every 1 minute, and will generate a new vhost cron every 15mins
* Place cron files in **/var/www/vhosts/fqdn.com/cron** , see example **/var/www/vhosts/localhost/cron/example**

# VHOST_MONITOR_CERTS (enabled by default)
## Gracefully restarts openlitespeed to apply certificate updates, will only restart once every 300s
* set VHOST_MONITOR_CERTS to false to disable, enabled by default
* monitors /var/www/vhosts/*/certs, looking for changes (only detects *.pem)

# Included Modules:
* cache
* mod_js
* mod_security
* modgzip
* modinspector
* modpagespeed
* modreqparser
* uploadprogress

# Ports
* 80 : http
* 443 : httpS
* 443/udp : quic aka http/2
* 7080 : webadmin
* 8088 : example

# Default WebAdmin Login
* https://127.0.0.1:7080
* user: admin
* Password: please use the password set below

# To set your own password
replace container name with the container name, eg xs_openlitespeed_1
```
docker exec -ti containername /bin/bash '/usr/local/lsws/admin/misc/admpass.sh'
```

# Check the headers
```
curl -XGET --resolve domain.com:443:ip.ad.re.ss https://domain.com -k -I
```
