#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
rm index.html
echo "<html><body background=\"https://ps-122022.website.yandexcloud.net/background.jpg\"></body></html>" > index.html