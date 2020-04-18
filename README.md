# eXtremeSHOK.com Docker OpenLiteSpeed with mod_security and pagespeed on Ubuntu 18.04

## This is a base image used by the extremeshok/openlitespeed-php image

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

# Included Modules:
* cache
* mod_security
* modgzip
* modinspector
* pagespeed
* uploadprogress

# Usage
Place files in **/var/www/vhosts/fqdn.com/** , see example **/var/www/vhosts/localhost/**

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
