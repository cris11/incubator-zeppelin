#!/bin/bash
set -e
source $2/$3
zephome=$1
envhome=$2
envfile=$3
#envitem=$4
src="/zeppelin-${SPARK_VER}"
#target="./zeppelin-${SPARK_VER}-test"
target="/zeppelin-${SPARK_VER}-test"
SPARK_SHARE=/reposhare/$BUILD_TYPE
SPARK_DAT=spark-${SPARK_VER}-bin-hadoop${HADOOP_VER}

Xvfb $DISPLAY -ac -screen 0 1280x1024x24 > $zephome/xvfb.log 2>&1 &
pid=`echo $!`

echo "# Xvfb Starting..."
cat $zephome/xvfb.log
echo ""

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
\cp -f /tmp/zeppelin-env.sh $zephome/conf/
echo "export SPARK_HOME=$SPARK_SHARE/$SPARK_DAT" >> $zephome/conf/zeppelin-env.sh

if [[ $BUILD_TYPE == "spark_yarn" ]]; then
	echo "- copy spark conf."
	\cp -f /tmp/spark_conf/*  ${SPARK_SHARE}/${SPARK_DAT}/conf/
fi

# --------------------------------------------------
# copy installed source ( container aufs to host fs )
# --------------------------------------------------
cd $zephome; cd ..
if [ ! -d $target ]; then
	\cp -rf $src $target
fi

### test ver
###\cp -rf /reposhare/zepp/$src $target

# --------------------------------------------------
# run scripts
# --------------------------------------------------
echo ""
echo -n "# Current DIR : "
pwd
echo ""

cd $target
$envhome/script.sh
ret=`echo $?`

# --------------------------------------------------
# remove source
# --------------------------------------------------
# Stop Xvfb
if kill -0 $pid; then
	kill $pid
fi

echo "# remove souce"

# install source
rm -rf $src

# test source
cd ..
rm -rf $target

# --------------------------------------------------
# end of scripts
# --------------------------------------------------
