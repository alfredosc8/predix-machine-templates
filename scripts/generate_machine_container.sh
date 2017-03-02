#!/bin/bash
CURRENT_DIR="`pwd`"
#######Functions
##################### Variables Section End   #####################
function getRepoURL {
	local  repoURLVar=$2
	reponame=$(echo "$1" | awk -F "/" '{print $NF}')
	url=$(echo "$a" | sed -n "/$reponame/p" $CURRENT_DIR/version.json | awk -F"\"" '{print $4}' | awk -F"#" '{print $1}')
	eval $repoURLVar="'$url'"
}
function getRepoVersion {
	local  repoVersionVar=$2
	reponame=$(echo "$1" | awk -F "/" '{print $NF}')
	repo_version="$(echo "$a" | sed -n "/$reponame/p" $CURRENT_DIR/version.json | awk -F"\"" '{print $4}' | awk -F"#" '{print $NF}')"
	eval $repoVersionVar="'$repo_version'"
}
__echo_run() {
  echo $@
  $@
  return $?
}

__print_center() {
  len=${#1}
  sep=$2
  buf=$((($COLUMNS-$len-2)/2))
  line=""
  for (( i=0; i < $buf; i++ )) {
  line="$line$sep"
  }
  line="$line $1 "
  for (( i=0; i < $buf; i++ )) {
    line="$line$sep"
  }
  echo ""
  echo $line
}
#######Functions end##########
arguments="$*"
rm -rf predix-scripts
getRepoURL "predix-scripts" predix_scripts_url
getRepoVersion "predix-scripts" predix_scripts_version
echo "predix_scripts_url : $predix_scripts_url"
echo "predix_scripts_version : $predix_scripts_version"
__echo_run git clone "$predix_scripts_url" -b $predix_scripts_version

__print_center "Creating Machine Container" "#"

source predix-scripts/bash/readargs.sh -cm $arguments
source predix-scripts/bash/scripts/files_helper_funcs.sh

if type dos2unix >/dev/null; then
find predix-scripts -name "*.sh" -exec dos2unix -q {} \;
fi
cd predix-scripts/bash

./quickstart.sh -cm $arguments

echo "MACHINE_CONTAINER_TYPE : $MACHINE_CONTAINER_TYPE"
echo "MACHINE_VERSION : $MACHINE_VERSION"
cp $CURRENT_DIR/predix-scripts/bash/PredixMachine$MACHINE_CONTAINER_TYPE-$MACHINE_VERSION.zip $CURRENT_DIR

pwd
