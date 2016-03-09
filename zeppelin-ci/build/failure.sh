#!/bin/bash
set -e
source $2/$3
zephome=$1
envhome=$2
envfile=$3
src="/zeppelin-${SPARK_VER}"
src_test="./zeppelin-${SPARK_VER}-test"

# run scripts
#echo ""; cd $zephome
#cp -rf /zeppelin-$SPARK_VER  $src-test/zeppelin-$SPARK_VER-test
#cp -rf $src ${src}-${SPARK_VER}-test

if [ -d $src ]; then
	cd $src
else
	cd $zephome; cd ..
	cd $src_test
fi

$envhome/failure.sh
