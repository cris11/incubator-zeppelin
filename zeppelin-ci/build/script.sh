#!/bin/bash
set -e
source $2/$3
zephome=$1
envhome=$2
envfile=$3
src="/zeppelin-${SPARK_VER}"
SPARK_SHARE=/reposhare/$BUILD_TYPE
SPARK_DAT=spark-${SPARK_VER}-bin-hadoop${HADOOP_VER}

# confirm spark binary
if [ ! -d $SPARK_SHARE/$SPARK_DAT ]; then
	SPARK_BIN=$SPARK_DAT.tgz
	tar xfz /reposhare/$SPARK_BIN -C $SPARK_SHARE
fi

# set spark home
\cp -f /tmp/zeppelin-env.sh $zephome/conf/
echo "export SPARK_HOME=$SPARK_SHARE/$SPARK_DAT" >> $zephome/conf/zeppelin-env.sh

if [[ $BUILD_TYPE == "spark_yarn" ]]; then
	echo "- copy spark conf."
	\cp -f /tmp/spark_conf/*  ${SPARK_SHARE}/${SPARK_DAT}/conf/
fi

# run scripts
#echo ""; cd $zephome
#cp -rf /zeppelin-$SPARK_VER  $src-test/zeppelin-$SPARK_VER-test
cp -rf $src ${src}-test
echo ""; cd ${src}-test
$envhome/script.sh
