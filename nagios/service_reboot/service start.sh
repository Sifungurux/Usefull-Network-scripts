#!/bin/sh
NOW=$(date +"%m-%d-%y %r")
CURRENTDIR=`pwd`

/usr/sbin/service apache2 status
STATUS="$(/usr/sbin/service apache2 status )"

if [ "$STATUS" = "Apache2 is NOT running." ]; then
        /usr/sbin/service apache2 start
        echo "At ${NOW} has Apache2 been rebootet " >> $CURRENTDIR/apacheScript.log 
fi