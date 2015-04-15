#!/bin/bash

echo "waiting 30 seconds.... "
sleep 30


. $('pwd')/config.sh

############

chroot $container_dir systemctl enable sshd
chroot $container_dir systemctl enable httpd
chroot $container_dir systemctl enable mariadb
chroot $container_dir systemctl enable memcached



chroot $container_dir systemctl start sshd
chroot $container_dir systemctl start httpd
chroot $container_dir systemctl start mariadb
chroot $container_dir systemctl start memcached


###############

echo "systemctl enable httpd" | ssh -i .ssh/$container_name localhost -p $container_sshd_port
echo "systemctl enable mariadb" | ssh -i .ssh/$container_name localhost -p $container_sshd_port
echo "systemctl enable memcached" | ssh -i .ssh/$container_name localhost -p $container_sshd_port
#echo "systemctl enable sshd" | ssh -i .ssh/$container_name localhost -p $container_sshd_port

echo "systemctl restart httpd" | ssh -i .ssh/$container_name localhost -p $container_sshd_port
echo "systemctl restart mariadb" | ssh -i .ssh/$container_name localhost -p $container_sshd_port
echo "systemctl restart memcached" | ssh -i .ssh/$container_name localhost -p $container_sshd_port
#echo "systemctl restart sshd" | ssh -i .ssh/$container_name localhost -p $container_sshd_port


### MySQL post actions
# echo "show databases" |  ssh -i .ssh/LAMPtest localhost -p2224 mysql
# ssh -i .ssh/LAMPtest localhost -p 2224 mysql < ./M/sos.sql

### Insert all sql files into mysql

echo "flush privileges;" | ssh -i .ssh/$container_name localhost -p $container_sshd_port mysql

FILES=./M/*.sql
for f in $FILES
do
 echo "Inserting $f into mysql"
 echo " ssh -i .ssh/$container_name localhost -p $container_sshd_port mysql < $f"
 ssh -i .ssh/$container_name localhost -p $container_sshd_port mysql < $f
done

echo "flush privileges;" | ssh -i .ssh/$container_name localhost -p $container_sshd_port mysql

####


