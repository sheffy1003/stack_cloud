#!/bin/bash

#MOUNT EC2 INSTANCE TO EFS
sudo yum update -y
sudo yum install -y nfs-utils
FILE_SYSTEM_ID=${efs_id}
sudo mkdir -p ${MOUNT_POINT}
sudo chown ec2-user:ec2-user ${MOUNT_POINT}
echo ${efs_id}.efs.${REGION}.amazonaws.com:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
sudo mount -a -t nfs4
sudo chmod -R 755 ${MOUNT_POINT}

#finish installing php, linux and configuring permission
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd
sudo usermod -a -G apache ec2-user
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


####DOWNLOAD PHPMYADMIN #####
cd /var/www/html
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
rm phpMyAdmin-latest-all-languages.tar.gz
sudo chkconfig httpd on


#####INSTALL WORDPRESS####
wget https://wordpress.org/wordpress-5.1.1.tar.gz
tar -xzf wordpress-5.1.1.tar.gz
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
cp -r wordpress/* /var/www/html/
sudo sed -i 's/database_name_here/${DB_NAME}/' /var/www/html/wp-config.php
sudo sed -i 's/username_here/${DB_USER}/' /var/www/html/wp-config.php
sudo sed -i 's/password_here/${DB_PASSWORD}/' /var/www/html/wp-config.php

###CREATE WORDPRESS DATABASE AND USER#
export DEBIAN_FRONTEND="noninteractive"
sudo mysql -u root <<EOF
CREATE USER 'wordpress-user'@'localhost' IDENTIFIED BY 'stackinc';
CREATE DATABASE \`stack-wordpress-db3\`;
USE \`stack-wordpress-db3\`;
GRANT ALL PRIVILEGES ON \`stack-wordpress-db3\`.* TO 'wordpress-user'@'localhost';
FLUSH PRIVILEGES;
show tables;
EOF

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
sudo systemctl start mariadb

