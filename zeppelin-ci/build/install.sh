#!/bin/bash
set -e
source $2/$3
zephome=$1
envhome=$2
envfile=$3
src="/zeppelin-${SPARK_VER}"

# ----------------------------------------------
# source copy
# ----------------------------------------------
#cd $zephome
if [ ! -d $src ]; then
	cp -rf $zephome $src
fi

#\cp -rf $zephome $src
cd $src
$envhome/install.sh
