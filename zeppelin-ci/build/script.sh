#!/bin/bash
set -e
source $2/$3
zephome=$1
envhome=$2
envfile=$3
src="/zeppelin-${SPARK_VER}"
target="/zeppelin-${SPARK_VER}"
#target="./zeppelin-${SPARK_VER}-test"
#target="/zeppelin-${SPARK_VER}-test"
#SPARK_SHARE=/reposhare/$BUILD_TYPE
SPARK_SHARE=/$BUILD_TYPE
SPARK_DAT=spark-${SPARK_VER}-bin-hadoop${HADOOP_VER}


#Xvfb $DISPLAY -ac -screen 0 1280x1024x24 > /reposhare/xvfb-${BUILD_TYPE}-${SPARK_VER}.log 2>&1 &
#pid=`echo $!`
#sleep 2

#echo "# Xvfb Starting..."
#echo "# PID : ${pid}"
#cat reposhare/xvfb-${BUILD_TYPE}-${SPARK_VER}.log
#echo ""


# --------------------------------------------------
# confirm spark binary
# --------------------------------------------------
#if [ ! -d $SPARK_SHARE/$SPARK_DAT ]; then
#	SPARK_BIN=$SPARK_DAT.tgz
#	tar xfz /reposhare/$SPARK_BIN -C $SPARK_SHARE
#fi

# --------------------------------------------------
# copy installed source ( container aufs to host fs )
# --------------------------------------------------
#if [ ! -d $target ]; then
### ori ver
	#cd $zephome; cd ..
	#\cp -rf $src $target

### test ver
#	\cp -rf /reposhare/zepp/$src $target
#fi

# --------------------------------------------------
# set spark home
# --------------------------------------------------
#\cp -f /tmp/zeppelin-env.sh $zephome/conf/
#echo "export SPARK_HOME=$SPARK_SHARE/$SPARK_DAT" >> $zephome/conf/zeppelin-env.sh

if [[ $BUILD_TYPE == "spark_yarn" ]]; then
	\cp -f /tmp/spark_conf/*  ${SPARK_SHARE}/${SPARK_DAT}/conf/
fi
\cp -f /tmp/zeppelin-env.sh $target/conf/
echo "export SPARK_HOME=$SPARK_SHARE/$SPARK_DAT" >> $target/conf/zeppelin-env.sh


# --------------------------------------------------
# run scripts
# --------------------------------------------------
#echo -n "# Current DIR : "
#pwd; echo ""

cd $target
$envhome/script.sh

# --------------------------------------------------
# remove source
# --------------------------------------------------
# Stop Xvfb
#echo "# Stopping Xvfb - PID(${pid})"
#if kill -0 $pid; then
#	kill $pid
#fi

echo "# remove souce : ${target}"; cd ..
rm -rf $target

# install source
#rm -rf $src
#
# test source
##cd ..
##rm -rf $target

# --------------------------------------------------
# end of scripts
# --------------------------------------------------
