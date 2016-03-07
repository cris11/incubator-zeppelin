#!/bin/bash
set -e
source $2/$3

zephome=$1
envhome=$2
envfile=$3

cd $zephome
$envhome/install.sh
