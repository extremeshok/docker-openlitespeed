# eXtremeSHOK.com Docker OpenLiteSpeed with modsecurity and pagespeed on Ubuntu 18.04

* Ubuntu 18.04 with S6
* cron (/etc/cron.d) enabled for scheduling tasks, run as user nobody
* OpenLiteSpeed Repository
* IONICE set to -10
* Low memory usage
* HEALTHCHECK activated
* Graceful shutdown
* Install Modules: pagespeed, modsecurity

# Usage
Place files in **/var/www/vhosts/fqdn.com/** , see example **/var/www/vhosts/localhost/**

# Default WebAdmin Login
* https://127.0.0.1:7080
* user: admin
* password: password

# To set your own password
replace container name with the container name, eg xs_openlitespeed_1
```
docker exec -ti containername /bin/bash '/usr/local/lsws/admin/misc/admpass.sh'
```
