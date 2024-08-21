# vsftpd-alpine
Vsftpd Docker image based on alpine forked from MagicArena/vsftpd-alpine. Supports passive mode, SSL and virtual users.

### SSL Key 生成

```shell
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt
```

### docker compose 运行

```shell
docker compose up
```

docker-compose.yml文件中环境变量最好抽取到.env文件中。采用 `env_file: .env`引入到docker-compose.yml文件中。  

### Docker 运行

```shell
docker build -t myftp .

docker run \
-d \
-v ./data:/home/vsftpd \
-p 21:21 \
-p 21100-21110:21100-21110 \
-e FTP_USER=myuser \
-e FTP_PASS=mypass \
-e PASV_ADDRESS=192.168.6.95 \
-e PASV_MIN_PORT=21100 \
-e PASV_MAX_PORT=21110 \
--name vsftpd --restart=always myftp
```

### 新增一个用户 seconduser，进入容器，运行

```shell
echo "seconduser:$(openssl passwd -1 password)" >> /etc/vsftpd/vuser_passwd
mkdir /home/vsftpd/seconduser/
chown -R ftpuser:ftpuser /home/vsftpd/seconduser
echo "" >> /etc/vsftpd/vuser_conf/seconduser
```

### 新增用户，目录设为其他路径

```shell
echo "anotheruser:$(openssl passwd -1 password)" >> /etc/vsftpd/vuser_passwd
mkdir /home/vsftpd/anotheruser/
mkdir /home/vsftpd/anotheruser/subdomain.com
chown -R ftpuser:ftpuser /home/vsftpd/anotheruser/subdomain.com
echo "local_root=/home/vsftpd/anotheruser/subdomain.com" >> /etc/vsftpd/vuser_conf/anotheruser
```



### 参考链接

https://blog.csdn.net/oarsman/article/details/136913925    passive 地址无法获取
https://blog.csdn.net/weixin_34026484/article/details/86235118    GnuTLS 错误 -15: An unexpected TLS packet was received.
https://www.liquidweb.com/blog/configure-vsftpd-ssl/
https://github.com/dagwieers/vsftpd/blob/master/EXAMPLE/VIRTUAL_USERS/README
https://github.com/r3back/docker-vsftpd
http://howto.gumph.org/content/setup-virtual-users-and-directories-in-vsftpd/

https://www.alibabacloud.com/help/en/ecs/how-to-construct-vsftp-and-configure-virtual-users
https://wiki.sharewiz.net/doku.php?id=ubuntu:ftp:vsftp:virtual_users_in_vsftpd
https://blog.csdn.net/qq_34777982/article/details/138275878
https://help.ubuntu.com/community/vsftpd

https://wiki.centos.org/HowTos(2f)VirtualVsFtpd.html

https://security.appspot.com/vsftpd/vsftpd_conf.html

