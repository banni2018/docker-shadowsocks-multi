# About shadowsocks of Docker for multi-user
#
# Version:1.0.0

FROM ubuntu:14.04
MAINTAINER wangyongdong <wydchn@gmail.com>

RUN apt-get -qq update && \
    apt-get install -q -y wget build-essential python-pip python-m2crypto && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN pip install shadowsocks

#add chacha20
RUN wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz && \
    tar zxf LATEST.tar.gz && \
    cd libsodium* && \
    ./configure && make -j2 && make install && \
    ldconfig

#配置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
dpkg-reconfigure -f noninteractive tzdata

ADD shadowsocks.json /etc/
ADD start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh

CMD ["sh", "-c", "start.sh"]
