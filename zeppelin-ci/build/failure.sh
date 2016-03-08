#!/bin/bash
set -e
source $2/$3
zephome=$1
envhome=$2
envfile=$3
src="/zeppelin"

# run scripts
#echo ""; cd $zephome
#cp -rf /zeppelin-$SPARK_VER  $src-test/zeppelin-$SPARK_VER-test
#cp -rf $src ${src}-${SPARK_VER}-test

if [ ! -d "${src}-${SPARK_VER}-test" ]; then
	cd ${src}
else
	cd ${src}-${SPARK_VER}-test
fi

$envhome/failure.sh
