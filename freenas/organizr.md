#### Install and Configure Organizr
    pkg install -y nginx wget php70 php70-curl php70-pdo php70-sqlite3 php70-simplexml php70-zip php70-openssl curl php70-hash php70-json php70-session php70-pdo_sqlite

    sysrc nginx_enable=YES
    sysrc php_fpm_enable=YES
    wget https://github.com/causefx/Organizr/archive/master.zip
    unzip master.zip -d /usr/local/www
    rm master.zip
    chown -R www:www /usr/local/www/Organizr-master
    
#### Configure php-fpm
    Edit /usr/local/etc/php-fpm.conf with your favorite editor and make the following change:
    Add:
    listen = /var/run/php-fpm.sock
    listen.owner = www
    listen.group = www
    listen.mode = 0660
    
#### Create a php.ini from the template

    cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini

    Edit /usr/local/etc/php.ini with your favorite editor and make the following change:
    Code:
    date.timezone = "Universal"

    Uncomment the following line and change the setting to 0:
    Code:
    cgi.fix_pathinfo=0

#### Create or replace /usr/local/etc/nginx/nginx.conf with the following which is the default with the bare minimum changes required to run Organizr.

    user  www;
    worker_processes  1;

    events {
        worker_connections  1024;
    }

    http {
      include       mime.types;
      default_type  application/octet-stream;
      sendfile        on;
      keepalive_timeout  65;

      server {
        listen       80;
        server_name  localhost;

        root   /usr/local/www/Organizr-master;
       
        location / {
          index  index.php index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
          root   /usr/local/www/nginx-dist;
        }
     
        location ~ \.php$ {
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_pass unix:/var/run/php-fpm.sock;
          fastcgi_index index.php;
          fastcgi_param SCRIPT_FILENAME $request_filename;
          include fastcgi_params;
        }
      }
    }

restart jail and navigate to the ip:port

[Credit](https://gist.github.com/mow4cash/e2fd4991bd2b787ca407a355d134b0ff#apps)
