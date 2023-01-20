#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

dir=`realpath $1`
tcz=$2
dep=$2.dep

[ ! -z "$tcz" ] || exit 0
[ ! -f $dep.done ] || exit 0

mkdir -p $dir
cd $dir

H requesting $tcz...

if [ ! -f $tcz ]; then
    H Downloading TCZ file $tcz...
    wget http://tinycorelinux.net/13.x/x86_64/tcz/$tcz
fi

if [ ! -f $dep ]; then
    H Downloading DEP file $dep...
    wget http://tinycorelinux.net/13.x/x86_64/tcz/$dep || true
    if [ ! -f $dep ]; then
        wget -q -S -o $dep.txt --content-on-error -O $dep.err http://tinycorelinux.net/13.x/x86_64/tcz/$dep || true
        grep ' 404 ' $dep.txt || exit 1
        rm $dep.txt $dep.err
        touch $dep
    fi
fi

touch $dep.done

while read p; do
    $SCRIPT_DIR/_download_tcz.sh $dir $p
done <$dep

echo tce-load -i \$SCRIPT_DIR/$tcz >> $dir/tcz-install.sh
