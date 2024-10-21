#!/bin/bash

service vsftpd start
service vsftpd enable

#cat /etc/vsftpd.conf
#cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf_backup

useradd -m $FTP_USER
passwd $FTP_USER << EOF
$FTP_PASSWORD
$FTP_PASSWORD
EOF

cd $WP_DIR
usermod -d $WP_DIR $FTP_USER

chown -R $FTP_USER:$FTP_USER $WP_DIR

echo "$FTP_USER" >> /etc/vsftpd.chroot_list

service vsftpd stop

/usr/sbin/vsftpd
