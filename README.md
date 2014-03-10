Usefull-Network-scripts
=======================

Contains useful small script to is helpfull to remember tips to shell/bash scripting.

1. Service start.sh
	This is a sctipt that monitor a service to check its status and restart the current 
	service if it is down. And write it to a log file

2. BackupFileTest.sh
	Nagios backup test sctipt to check age and size of file.

3. Nagios passive
	This is a small shell script that execute a nagios plugin, checks on its return value
	and pipe it to a Nagios Server though NSCA 
	
4. Backup script
	This script was made in my ITS project for backup of config files if any reconfig and
	restore was needed. The script sends the date to a remote server after making a local 
	backup 
	
	