FROM ubuntu:16.04

WORKDIR /tmp

RUN apt-get update \
    && apt-get -y --no-install-recommends install ca-certificates curl build-essential cmake libuv1-dev git openssl libssl-dev libhwloc-dev

RUN git clone --depth 1 https://github.com/NineWoranop/xmrig.git \
    && cd xmrig \
    && mkdir build \
    && cd build \
    && cmake -DWITH_HTTPD=OFF .. \
    && make \
    && cd ../.. \
    && mv xmrig/build/xmrig /usr/local/bin/xmrig \
    && chmod a+x /usr/local/bin/xmrig \
    && apt-get -y remove ca-certificates curl build-essential cmake \
    && apt-get clean autoclean \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

RUN groupadd -g 2000 xmrig && \
    useradd -u 2000 -g xmrig -m -s /bin/bash xmrig && \
    echo 'xmrig:xmrig' | chpasswd

USER xmrig

ENTRYPOINT ["xmrig"]
CMD ["--help"]