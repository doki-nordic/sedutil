#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

H Copying scripts...
mkdir -p root/my
cp $SCRIPT_DIR/build.sh root/my
cp $SCRIPT_DIR/_build2.sh root/my
chown `id -un`:`id -gn` root/my/*

H Copying sedutil source code...
mkdir -p root/my/sedutil
cp -R `find $SCRIPT_DIR/../.. -maxdepth 1 ! -name tc-image ! -name '.*'` root/my/sedutil/

H Copying qjs source code...
mkdir -p root/my/qjs
cd root/my/qjs
tar --strip 1 -xJf $SCRIPT_DIR/../quickjs*.tar.xz
cd ../../..

H Copy TCZ files...
mkdir -p out/tcz
cp $SCRIPT_DIR/../downloads/build/*.tcz $SCRIPT_DIR/../downloads/build/*.sh out/tcz/
