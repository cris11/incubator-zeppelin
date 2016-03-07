#!/bin/bash
set -e
source $2/$3
zephome=$1
envhome=$2
envfile=$3
SPARK_SHARE=/reposhare/$BUILD_TYPE

# ----------------------------------------------------------------------
# Setup hadoop ( deafults )
# ----------------------------------------------------------------------
: ${HADOOP_PREFIX:=/usr/local/hadoop}
##$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# stopping
./spark-daemon.sh stop org.apache.spark.deploy.worker.Worker 1
./stop-master.sh

# stopping hadoop
$HADOOP_PREFIX/sbin/stop-dfs.sh
$HADOOP_PREFIX/sbin/stop-yarn.sh

##service sshd stop

# ----------------------------------------------------------------------
# End of Script
# ----------------------------------------------------------------------
