#!/bin/sh

HOST={nagios host}
SERVICE_DISK=BACKUP
SERVICE_LOAD=LOAD
NSCAHOST=192.168.x.x
NOW=$(date +"%m-%d-%y %r")
CURRENTDIR=`pwd`


${CURRENTDIR}/check_disk -w 300 -c 100 -p / >> nagios_disk_check.log
VAR="$(${CURRENTDIR}/check_disk -w 300 -c 200 -p / )"
RETVAL=$?

if [ ${RETVAL} -eq 2 ] ; then
  echo "$HOST\t$SERVICE_DISK\t$RETVAL\t${NOW} - ${VAR}" | /usr/sbin/send_nsca -H $NSCAHOST -c /etc/send_nsca.cfg
fi
if [ ${RETVAL} -eq 1 ] ; then
  echo "$HOST\t$SERVICE_DISK\t$RETVAL\t${NOW} - ${VAR}" | /usr/sbin/send_nsca -H $NSCAHOST -c /etc/send_nsca.cfg
fi
if [ ${RETVAL} -eq 0 ] ; then
  echo "$HOST\t$SERVICE_DISK\t$RETVAL\t${NOW} - ${VAR}" | /usr/sbin/send_nsca -H $NSCAHOST -c /etc/send_nsca.cfg 
fi



${CURRENTDIR}/check_load -w 7,12,15 -c 15,20,25 >> nagios_load_check.log
VAR="$(${CURRENTDIR}/check_load -w 7,12,15 -c 15,20,25)"
RETVAL=$?

if [ ${RETVAL} -eq 2 ] ; then
  echo "$HOST\t$SERVICE_LOAD\t$RETVAL\t${NOW} - ${VAR}" | /usr/sbin/send_nsca -H $NSCAHOST -c /etc/send_nsca.cfg
fi
if [ ${RETVAL} -eq 1 ] ; then
  echo "$HOST\t$SERVICE_LOAD\t$RETVAL\t${NOW} - ${VAR}" | /usr/sbin/send_nsca -H $NSCAHOST -c /etc/send_nsca.cfg
fi
if [ ${RETVAL} -eq 0 ] ; then
  echo "$HOST\t$SERVICE_LOAD\t$RETVAL\t${NOW} - ${VAR}" | /usr/sbin/send_nsca -H $NSCAHOST -c /etc/send_nsca.cfg
fi
exit 0
