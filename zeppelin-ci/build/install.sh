#!/bin/bash
set -e
source $2/$3

zephome=$1
envhome=$2
envfile=$3

#cd $zephome

#if [[ ! -d /zeppelin ]; then
cp -rf $zephome /zeppelin-$SPARK_VER
cd /zeppelin-$SPARK_VER
$envhome/install.sh
