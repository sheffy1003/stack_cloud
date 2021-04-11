#!/bin/bash
yum update -y
sudo yum install -y nfs-utils
FILE_SYSTEM_ID=${efs_id}
sudo mkdir -p ${MOUNT_POINT}
sudo chown ec2-user:ec2-user ${MOUNT_POINT}
echo ${efs_id}.efs.${REGION}.amazonaws.com:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
sudo mount -a -t nfs4
yum install httpd php php-mysql -y
cd /var/www/html
echo "healthy" > healthy.html
wget https://wordpress.org/wordpress-5.1.1.tar.gz
tar -xzf wordpress-5.1.1.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf wordpress-5.1.1.tar.gz
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
sudo sed -i 's/database_name_here/stack-wordpress-db3/' /var/www/html/wp-config.php
sudo sed -i 's/username_here/wordpress-user/' /var/www/html/wp-config.php
sudo sed -i 's/password_here/stackinc/' /var/www/html/wp-config.php

## Allow wordpress to use Permalinks###
sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf
sudo chmod -R 755 wp-content
sudo chown -R apache:apache wp-content
chkconfig httpd on
service httpd start