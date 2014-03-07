#!/bin/sh
NOW=$(date +"%m-%d-%y %r")
CURRENTDIR=`pwd`
echo "test"
/usr/sbin/service apache2 status
STATUS=$?
if [ ${STATUS} -eq 3 ]; then
        /usr/sbin/service apache2 start
        echo "At ${NOW} has Apache2 been rebootet " >> $CURRENTDIR/apacheScript.log 
fi
