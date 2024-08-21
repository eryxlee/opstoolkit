FROM alpine:latest

LABEL maintainer="eryxlee <eryxlee@163.com>" \
      org.opencontainers.image.authors="eryxlee <eryxlee@163.com>" \
      org.opencontainers.image.url="https://eryxlee.github.com/" \
      org.opencontainers.image.version="v1.0.0" \
      org.opencontainers.image.vendor="agiexplained.com" \
      org.opencontainers.image.licenses="GPL-3.0-or-later" \
      org.opencontainers.image.created="2024-08-15T09:30:00Z" \
      org.opencontainers.image.ref.name="" \
      org.opencontainers.image.title="vsftp file server image" \
      org.opencontainers.image.description="vsftp file server image"

ENV TZ=Asia/Shanghai
ENV LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh'
ENV FTP_USER **String**
ENV FTP_PASS **Random**
ENV PASV_ADDRESS **IPv4**
ENV PASV_MIN_PORT 21100
ENV PASV_MAX_PORT 21110

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && apk upgrade && \
    apk --update add --no-cache curl tzdata vsftpd supervisor openssl && \
    mkdir -p /etc/zoneinfo/`dirname $TZ` && \
    cp /usr/share/zoneinfo/$TZ /etc/zoneinfo/$TZ && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apk del tzdata && \
    rm -rf /tmp/* /var/cache/apk/*

COPY libpam-pwdfile.zip /tmp/
RUN apk --update add --no-cache --virtual .build-dependencies build-base linux-pam-dev curl unzip shadow && \
    unzip -q /tmp/libpam-pwdfile.zip -d /tmp/ && \
    cd /tmp/libpam-pwdfile && \
    make install && \
    apk del .build-dependencies && \
    rm -rf /tmp/* /var/cache/apk/*

COPY setup.sh /usr/sbin/
COPY ./vsftpd/etc/pam.d/vsftpd_virtual /etc/pam.d/
COPY ./vsftpd/etc/vsftpd /etc/vsftpd
COPY ./supervisor/supervisord.conf /etc/
COPY ./supervisor/supervisor.d /etc/supervisor.d

RUN set -ex && \
    chmod +x /usr/sbin/setup.sh && \
    mkdir -p /var/log/vsftpd/ && \
    mkdir -p /etc/vsftpd/vuser_conf/ && \
    mkdir -p /var/mail/ && \
    adduser ftpuser -D -h /home/vsftpd/ -s /sbin/nologin && \
    chown -R ftpuser:ftpuser /home/vsftpd/

VOLUME /home/vsftpd
VOLUME /var/log/vsftpd

EXPOSE 20 21 21100-21110

CMD ["/bin/sh", "-c", "/usr/sbin/setup.sh; /usr/bin/supervisord"]