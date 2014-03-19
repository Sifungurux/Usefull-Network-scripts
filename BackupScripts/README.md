INTRODUCTION

This is a small script that takes a local backup of selected files or directories and compress it with a date format in a date folder. The script is controlled by a cronjob.

Start by making a ssh key pair 
	ssh-keygen -t rsa

Remember to give it a passphrase to make it more secure

Place your keys in the /root/.ssh folder so it later would be able to use the key.pub for login into the web service.

Find the ssh configuration.
In Debian it is located at /etc/ssh/
Use your favorite editing tool a edit the ssh_config file.

Add your ssh configuration at the bottom like this

host <ip or URL>
indentityFile ~./ssh/<Name of your private key>
User <Your username>

SSH to your backup server normally 

ssh user@ip 

Navigate to /root/.ssh/ autorizred_Keys and add your public key under the existing one.

Now you are able to ssh like this

ssh <IP or URL>


Now configure your server for sending the backups

Setting up the cronjob

	Crontab -e

scroll to the bottom and add this to the 
	# m h day month year   command
 	00 07 * * * /bin/bash /backup/backupscript.sh


This will execute the script every day at 7am all of the 365 days in the year

I have placed the script in may backup folder so any changes i make without committing it here will be backup

Remember to edit the script so the right folders will be backed up… 

Good luck and have fun



