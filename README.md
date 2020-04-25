# eXtremeSHOK.com Docker OpenLiteSpeed with mod_security and pagespeed on Ubuntu 18.04

## Uses the base image docker-baseimage-ubuntu : https://hub.docker.com/r/extremeshok/baseimage-ubuntu

## Checkout our optimized production web-server setup based on docker https://github.com/extremeshok/docker-webserver

## Note all configs are optimized and designed for production usage

* Ubuntu 18.04 with S6
* cron (/etc/cron.d) enabled for scheduling tasks, run as user nobody
* Optimized OpenLiteSpeed configs
* OpenLiteSpeed Repository
* IONICE set to -10
* Low memory usage
* HEALTHCHECK activated
* Graceful shutdown
* accesslog = stdout
* errorlog = stderr
* configs located in /etc/openlitespeed/
* default configs will be added if the config dir is empty
* OWASP modsecurity rules enabled
* Restart openlitespeed when changes to the vhost/domain.com/cert dirs are detected, ie ssl certificate is updated

# VHOST_CRON_ENABLE (disabled by default)
## generate cron from cron files located in vhost/cron (hourly)
* set VHOST_CRON_ENABLE to true to enable, disabled by default
* finds all vhost/cron files and places them in the /etc/cron.d/ , runs hourly
* Place cron files in **/var/www/vhosts/fqdn.com/cron** , see example **/var/www/vhosts/localhost/cron/example**

# Included Modules:
* cache
* mod_security
* modgzip
* modinspector
* pagespeed
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
