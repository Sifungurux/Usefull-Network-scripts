
#!/bin/bash
#purpose  = backing up important config data
#created the 1/12/13
#Author = Jonas Pedersen
#version 0.2 - added logs and directories
#Start of program

TIME=`date +"%b-%d-%y"`
FILENAME="backup-$TIME.tar.gz"
#################################
#       Backup Folders
#################################
PROFTP="/etc/proftpd"
PROFTPLOG="/var/log/proftpd/proftpd.log"
APACHE="/etc/apache2"
APACHELOG="/var/log/apache2"
USERDATA="/home/FTPWEB"
SYSLOG="/var/log/syslog"
DESDIR="/backup"
##################################

mkdir $TIME

tar -cpzf $DESDIR/$TIME/"ProFtp-"$FILENAME $PROFTP
tar -cpzf $DESDIR/$TIME/"Apache-"$FILENAME $APACHE
tar -cpzf $DESDIR/$TIME/"ClientData-"$FILENAME $USERDATA
tar -cpzf $DESDIR/$TIME/"ProFtpLog-"$FILENAME $PROFTPLOG
tar -cpzf $DESDIR/$TIME/"Apache2Log-"$FILENAME $APACHELOG
tar -cpzf $DESDIR/$TIME/"Syslog-"$FILENAME $SYSLOG



scp -r  /backup/ "Login Info for Storage":/home/ubuntu/backups/ftp
#END OF SCRIPT

