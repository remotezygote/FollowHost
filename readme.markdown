*** Easy Dynamic DNS using Route53 from Amazon AWS

To install, just put this script some where (/usr/local/bin is a good place), and set up a cron job like so:

0 * * * * /usr/local/bin/updatedns -a <amazon access key> -s "<amazon secret key>" -n <host name>

You'll need an AWS account, of course, and you just replace the values above with your generated access keys. You'll need to have the zone and host record created already (just put in your current IP to start). The script pulls out and finds the zone and host records and updates them with your current external IP (by scraping it off of the myip.dk IP service). Set it up to update as often as you want via cron's scheduling mechanism.