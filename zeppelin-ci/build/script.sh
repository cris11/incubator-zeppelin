#!/bin/bash
set -e
source $2/$3
zephome=$1
envhome=$2
envfile=$3
target="/zeppelin-${SPARK_VER}"
SPARK_SHARE="/reposhare/$BUILD_TYPE"
SPARK_DAT=spark-${SPARK_VER}-bin-hadoop${HADOOP_VER}

# --------------------------------------------------
# confirm spark binary
# --------------------------------------------------
if [ ! -d $SPARK_SHARE/$SPARK_DAT ]; then
	SPARK_BIN=$SPARK_DAT.tgz
	tar xfz /reposhare/$SPARK_BIN -C $SPARK_SHARE
fi

# --------------------------------------------------
# set spark home
# --------------------------------------------------
if [[ $BUILD_TYPE == "spark_yarn" ]]; then
	\cp -f /tmp/spark_conf/*  ${SPARK_SHARE}/${SPARK_DAT}/conf/
fi
\cp -f /tmp/zeppelin-env.sh $target/conf/
echo "export SPARK_HOME=$SPARK_SHARE/$SPARK_DAT" >> $target/conf/zeppelin-env.sh

# --------------------------------------------------
# run scripts
# --------------------------------------------------
cd $target
$envhome/script.sh

# --------------------------------------------------
# remove source
# --------------------------------------------------
echo "# remove souce : ${target}"; cd ..
rm -rf $target

# --------------------------------------------------
# end of scripts
# --------------------------------------------------
