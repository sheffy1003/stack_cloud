#!/bin/bash
sudo yum update -y
sudo yum install -y nfs-utils
FILE_SYSTEM_ID=${efs_id}
sudo mkdir -p ${MOUNT_POINT}
sudo chown ec2-user:ec2-user ${MOUNT_POINT}
echo ${efs_id}.efs.${REGION}.amazonaws.com:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
sudo mount -a -t nfs4
sudo chmod -R 755 ${MOUNT_POINT}
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd
sudo usermod -a -G apache ec2-user

#finish installing php, linux and configuring permission
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo systemctl start mariadb
#sudo mysql_secure_installation
sudo systemctl enable mariadb
sudo yum install php-mbstring -y
sudo yum install php-xml -y
sudo systemctl restart httpd
sudo systemctl restart php-fpm


####INSTALL PHPMYADMIN #####
cd /var/www/html
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
rm phpMyAdmin-latest-all-languages.tar.gz
sudo systemctl start mariadb
sudo chkconfig httpd on
sudo chkconfig mariadb on
sudo systemctl status httpd
sudo systemctl status mariadb

#####INSTALL WORDPRESS####
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cp -r wordpress/* /var/www/html/

sudo sed -i 's/database_name_here/${DB_NAME}/' /var/www/html/wp-config.php
sudo sed -i 's/username_here/${DB_USER}/' /var/www/html/wp-config.php
sudo sed -i 's/password_here/${DB_PASSWORD}/' /var/www/html/wp-config.php
sudo sed -i 's/localhost/${RDS_ENDPOINT}/' /var/www/html/wp-config.php

## Allow wordpress to use Permalinks###
sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf

###CHANGE OWNERSHIP FOR APACHE AND RESTART SERVICES###
sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo systemctl restart httpd
sudo systemctl enable httpd && sudo systemctl enable mariadb
sudo systemctl status mariadb
sudo systemctl start mariadb
sudo systemctl status httpd
sudo systemctl start httpd
