SiteUppity.com
==============

SiteUppity is a simple website ping/status checker. It's built using Python 2.7 and the Bottle framework: http://bottlepy.org (pip install bottle). Once you have both installed, simply type 'python app.py' and visit http://127.0.0.1:8080 in your browser to view the website.

The app is deployed on an Ubuntu server using nginx and Apache. nginx config:

    upstream su_apache {
        server 127.0.0.1:8080;
    }

    server {
        listen 80;
        server_name siteuppity.com;

        location /static {
                root /var/www/siteuppity/static;
        }
        
        location / {
                proxy_pass http://su_apache;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
        }
    }

Apache config:

    <VirtualHost 127.0.0.1:8080>
	    ServerName siteuppity.com
	    DocumentRoot /var/www/siteuppity
	    WSGIDaemonProcess siteuppity python-path=/var/www/siteuppity user=www-data group=www-data processes=1 threads=1
	    WSGIProcessGroup SiteUppity
	    WSGIScriptAlias / /var/www/src/siteuppity/app.py process-group=SiteUppity
    
	    <Directory /var/www/html/websites/siteuppity>
		    <Files app.py>
			    Require all granted
		    </Files>
	    </Directory>
    </VirtualHost>

If you use a significant portion of this source code in your projects, please include an attribution link back to siteuppity.com or this repo. Thank you!
