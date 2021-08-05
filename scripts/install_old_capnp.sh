#!/usr/bin/bash
VERSION=0.6.1

mount -o rw,remount /
mount -o rw,remount /system
cd /tmp
rm -rf capnproto-c++-${VERSION}
wget --tries=inf https://capnproto.org/capnproto-c++-${VERSION}.tar.gz
tar xvf capnproto-c++-${VERSION}.tar.gz

pushd capnproto-c++-${VERSION}

# Patch for 0.6.1
patch -p1 < /data/openpilot/scripts/capnp.patch
CXXFLAGS="-fPIC -O2" ./configure --prefix=/usr
make -j4 install
popd

rm -rf c-capnproto
git clone https://github.com/commaai/c-capnproto.git
pushd c-capnproto
git submodule update --init --recursive
CFLAGS="-fPIC -O2" autoreconf -f -i -s
CFLAGS="-fPIC -O2" ./configure --prefix=/usr
gcc -fPIC -O2 -c lib/capn-malloc.c
gcc -fPIC -O2 -c lib/capn-stream.c
gcc -fPIC -O2 -c lib/capn.c
ar rcs libcapn.a capn-malloc.o capn-stream.o capn.o

cp libcapn.a /usr/lib
make -j4 install
mount -o ro,remount /
mount -o ro,remount /system
popd
