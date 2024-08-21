#!/bin/sh

export GLOBAL_CONFIG_FILE="/etc/vsftpd/vsftpd.conf"

# 如未设置账号名，默认为admin
if [ "$FTP_USER" = "**String**" ]; then
  export FTP_USER='admin'
fi

# 如未设置密码，默认生成随机密码
if [ "$FTP_PASS" = "**Random**" ]; then
  export FTP_PASS=`cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16}`
  echo "FTP account user name: $FTP_USER  password: $FTP_PASS"
fi

# 如未设置被动模式主机地址，默认生成本机真实IP
if [ "$PASV_ADDRESS" = "**IPv4**" ]; then
  export PASV_ADDRESS=$(curl -s -4 --connect-timeout 5 --max-time 10 ifconfig.co)
fi

# 设置被动模式参数
sed -i "s/{{PASV_MIN_PORT}}/$PASV_MIN_PORT/g" ${GLOBAL_CONFIG_FILE}
sed -i "s/{{PASV_MAX_PORT}}/$PASV_MAX_PORT/g" ${GLOBAL_CONFIG_FILE}
sed -i "s/{{PASV_ADDRESS}}/$PASV_ADDRESS/g" ${GLOBAL_CONFIG_FILE}

# 创建初始用户
mkdir /home/vsftpd/${FTP_USER}/ 
chown -R ftpuser:ftpuser /home/vsftpd/${FTP_USER}/
echo "" >> /etc/vsftpd/vuser_conf/${FTP_USER}
echo "${FTP_USER}:$(openssl passwd -1 ${FTP_PASS})" >> /etc/vsftpd/vuser_passwd
