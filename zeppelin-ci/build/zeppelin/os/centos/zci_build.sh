#!/bin/bash
set -e
# ----------------------------------------------------------------------
# Init
# ----------------------------------------------------------------------
ENV_FILE=$1
USER_HOME=$2
BUILD_HOME=$3
ZEPP_ID=$4
source $ENV_FILE

# ----------------------------------------------------------------------
# Define Variable
# ----------------------------------------------------------------------
MVN_BIN="/usr/local/bin/mvn"
ZEPP_HOME=$BUILD_HOME/$ZEPP_ID
MVN_OPT_FLAG="-Dmaven.repo.local=$ZEPP_HOME/.m2 -s /tmp/build/reposhare/conf/maven-settings.xml"
MVN_DEP_FLAG="dependency:list $MVN_OPT_FLAG"

BUILDSTEP_TIMEOUT=300
#BUILDSTEP_BIN=/buildstep.sh
BUILDSTEP_BIN=$USER_HOME/zeppelin/zeppelin-ci/build/buildstep.sh
BUILDSTEP_DIR=/tmp/build/reposhare/buildstep/build
BUILDSTEP=${ZEPP_ID}.bs

$BUILDSTEP_BIN init $BUILDSTEP_DIR $BUILDSTEP_TIMEOUT
$BUILDSTEP_BIN log $BUILDSTEP "# Start, zeppelin build ..."

cd $USER_HOME/zeppelin
$MVN_BIN $MVN_DEP_RUN


# ----------------------------------------------------------------------
# Build Script
# ----------------------------------------------------------------------
arg_num=0
IFS=' '
read -r -a SPARK_VERSIONS <<< "$SPARK_VERSION"
for i in "${SPARK_VERSIONS[@]}"
do
	SPARK_VERSION=$i
	SPARK_PROFILE=${SPARK_VERSION%.*}
	HADOOP_PROFILE=${HADOOP_VERSION%.*}


	##### Build Step 1
	$BUILDSTEP_BIN log $BUILDSTEP "- $BUILDSTEP : set build-flags for spark $SPARK_VERSION"

	if [[ $arg_num == 0 ]]; then
		BUILD_PROFILE="-Pspark-$SPARK_PRO -Phadoop-$HADOOP_VER -Ppyspark -Pscalding"
		BUILD_FLAG="package -Pbuild-distr"
	else
		BUILD_PROFILE="-Pspark-$SPARK_PRO -Phadoop-$HADOOP_VER -Ppyspark"
		BUILD_FLAG="package -DskipTests"
	fi
	let "arg_num+=1"

	# ---------------------------------------
	#  copy source
	# ---------------------------------------
	cd $USER_HOME
	cp -rf zeppelin zeppelin_$SPARK_VERSION


	##### Build Step 2
	$BUILDSTEP_BIN log $BUILDSTEP "- $BUILDSTEP : started zeppelin build for spark $SPARK_VERSION"

	cd zeppelin_$SPARK_VERSION
	$MVN_BIN $MVN_OPT_FLAG $BUILD_FLAG $PROFILE -B
	#/usr/local/bin/mvn $MVN_OPT_FLAG $BUILD_FLAG $PROFILE -B

	cd $USER_HOME
	mv zeppelin_$SPARK_VERSION $ZEPP_HOME/


	##### Build Step 3
	$BUILDSTEP_BIN log $BUILDSTEP "- $BUILDSTEP : finished zeppelin build for spark $SPARK_VERSION"
	sleep 1
done
echo "Zeppelin Build Done!"


# ----------------------------------------------------------------------
# End of Script
# ----------------------------------------------------------------------
