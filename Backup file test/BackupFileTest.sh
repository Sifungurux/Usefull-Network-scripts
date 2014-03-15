#!/bin/bash
NSCAHOST="192.168.100.165"
 
 
function PRINT_USAGE(){
  echo "This Nagios plugin checks backup folders :
  -H HOST Name from Host definition in the nagios
  -e SERVICE Name from the service definition in nagios config
  -d DIRECTORY  the directory to search for backup files
  -p PATTERN  an optionnal pattern for backup files
  -t HOURS  maximal age in hours for the latest backup before a warning is issued
  -T HOURS  maximal age in hours for the latest backup before a critical alert is issued
  -s KBYTES maximal size in kilo bytes for the latest backup before a warning is issued
  -S KBYTES maximal size in kilo bytes for the latest backup before a critical alert is issued
  -h Prints out this help

You must at least specify a directory and a minimal size or a minimal age."
  exit 0
}
 
HOST='';SERVICE='';WTIME=0;CTIME=0;WSIZE=0;CSIZE=0;DIR='';PATTERN=''
declare -i CTIME 
declare -i WTIME
declare -i CSIZE
declare -i WSIZE
while true ; do
  getopts 'H:e:t:T:s:S:d:p:h' OPT 
  if [ "$OPT" = '?' ] ; then break; fi; 
  case "$OPT" in
    "H") HOST="$OPTARG";;
    "e") SERVICE="$OPTARG";;
    "t") WTIME="$OPTARG";;
    "T") CTIME="$OPTARG";;
    "s") WSIZE="$OPTARG";;
    "S") CSIZE="$OPTARG";;
    "d") DIR="$OPTARG";;
    "p") PATTERN="$OPTARG";;
    "h") PRINT_USAGE;;
  esac
done

RETVAL=1
RETTXT='FAIL TO CHECK BACKUP'

if [ -z "$HOST" ] ; then
  echo ""
  echo "You must define a HOST"
  echo ""
  PRINT_USAGE
fi

if [ -z "$SERVICE" ] ; then
  echo ""
  echo "Service not defined! You must define a service name"
  echo ""
  PRINT_USAGE
fi

 
if [ -z "$DIR" -o '(' "$WTIME" = '0' -a "$CTIME" = '0'\
 -a "$WSIZE" = '0' -a "$CSIZE" = '0' ')' ] ; then
  PRINT_USAGE
fi
 
LASTFILE=$(ls -lt --time-style=+%s "$DIR" | grep -v "^total " | grep "$PATTERN"\
 | head -n 1 | sed 's/\s\+/ /g')
if [ -z "$LASTFILE" ] ; then
  echo "CRITICAL - no backup found in $DIR" 
  exit 2
fi
 
TIMESTAMP=$(cut -d ' ' -f 6 <<< "$LASTFILE")
BYTES=$(cut -d ' ' -f 5 <<< "$LASTFILE")
let "SIZE = $BYTES / 1024"
FILENAME=$(cut -d ' ' -f 7 <<< "$LASTFILE")
let "AGE = ( $(date +%s) - $TIMESTAMP ) / 3600"

RETTXT="OK - $FILENAME ($AGE hours old, $SIZE kb)"
RETVAL=0
 
if [ "$CTIME" -gt 0 -a "$AGE" -gt "$CTIME" ] ; then
  RETTXT="CRITICAL - $FILENAME is out of date ($AGE hours old)" 
  RETVAL=2
fi
 
if [ "$WTIME" -gt 0 -a "$AGE" -gt "$WTIME" ] ; then
  RETTXT="WARNING - $FILENAME is out of date ($AGE hours old)"  
  RETVAL=1
fi
 
if [ "$CSIZE" -gt 0 -a "$SIZE" -lt "$CSIZE" ] ; then
  RETTXT="CRITICAL - $FILENAME is too small ($SIZE kb)" 
  RETVAL=2
fi
 
if [ "$WSIZE" -gt 0 -a "$SIZE" -lt "$WSIZE" ] ; then
  RETTXT="WARNING - $FILENAME is too small ($SIZE kb)"  
  RETVAL=1
fi
echo "$HOST"
echo "$SERVICE"
echo "$RETVAL"
echo "$RETTXT"
echo -e "$HOST\t$SERVICE\t$RETVAL\t$RETTXT" | /usr/sbin/send_nsca -H $NSCAHOST -c /etc/send_nsca.cfg
exit 0
