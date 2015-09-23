SiteUppity.com
==============

SiteUppity is a simple website ping/status checker. It's built using Python and the Bottle framework: http://bottlepy.org. Once you have both installed, simply type 'python app.py' and visit http://127.0.0.1:8080 in your browser to view the website.

The app is deployed on an Ubuntu server using Apache. Here is the config file:
<VirtualHost 168.235.64.240:80>
    ServerName siteuppity.com
    DocumentRoot /var/www/SiteUppity
    WSGIDaemonProcess SiteUppity user=www-data group=www-data processes=1 threads=5
    WSGIScriptAlias / /var/www/SiteUppitySource/app.py
</VirtualHost>
