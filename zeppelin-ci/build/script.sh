#!/bin/bash
set -e
source $2/$3
zephome=$1
envhome=$2
envfile=$3
SPARK_SHARE=/reposhare/$BUILD_TYPE
SPARK_DAT=spark-${SPARK_VER}-bin-hadoop${HADOOP_VER}

\cp -f /tmp/zeppelin-env.sh $zephome/conf/
echo "export SPARK_HOME=$SPARK_SHARE/$SPARK_DAT" >> $zephome/conf/zeppelin-env.sh

if [[ $BUILD_TYPE == "spark_yarn" ]]; then
	echo "- copy spark conf."
	\cp -f /tmp/spark_conf/*  ${SPARK_SHARE}/${SPARK_DAT}/conf/
fi

cd $zephome
$envhome/script.sh
