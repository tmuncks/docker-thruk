#!/bin/bash

echo "Entrypoint script for Thruk started."

# configure logcache connection
sed -i -e '/^logcache=/d' /etc/thruk/thruk_local.conf
if [ ! -z "$LOGCACHE" ]; then
    echo "logcache=$LOGCACHE" >> /etc/thruk/thruk_local.conf
fi

# set initial password
if [ ! -s /etc/thruk/htpasswd ]; then
    PW="$(pwgen -y1 12)"
    htpasswd -b /etc/thruk/htpasswd thrukadmin "$PW"
    echo
    echo "### The password for thrukadmin has been set to: $PW"
    echo
    unset PW
fi

# run cron
if [ "$RUNCRON" == "1" ] || [ "$RUNCRON" == "yes" ] || [ "$RUNCRON" == "true" ]; then
    echo "Updating Thruk crontab and starting cron"
    thruk cron install
    cron
fi

# run
exec apache2ctl -DFOREGROUND -e info
