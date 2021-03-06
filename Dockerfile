FROM ubuntu:latest

MAINTAINER Sah Lee <contact@leesah.name>

ENV DEPENDENCIES git-core build-essential autoconf libtool libssl-dev asciidoc xmlto
ENV BASEDIR /tmp/shadowsocks-libev
ENV SERVER_PORT 8964

# Set up building environment
RUN apt-get update \
 && apt-get install --no-install-recommends -y $DEPENDENCIES

# Get the latest code, build and install
RUN git clone --recursive git://github/kalagxw/shadowsocks-libev.git $BASEDIR
WORKDIR $BASEDIR
RUN ./configure \
 && make \
 && make install

# Tear down building environment and delete git repository
WORKDIR /
RUN rm -rf $BASEDIR/shadowsocks-libev\
 && apt-get --purge autoremove -y $DEPENDENCIES

# Port in the config file won't take affect. Instead we'll use 8388.
EXPOSE $SERVER_PORT
EXPOSE $SERVER_PORT/udp

# Override the host and port in the config file.
ADD entrypoint /
ENTRYPOINT ["/entrypoint"]
CMD ["-h"]
