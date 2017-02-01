#!/bin/bash
set -e
CURRENT_DIR="`pwd`"
quickstartLogDir="$CURRENT_DIR/log"
# Creating a logfile if it doesn't exist
if ! [ -d "$quickstartLogDir" ]; then
mkdir "$quickstartLogDir"
chmod 744 "$quickstartLogDir"
touch "$quickstartLogDir/quickstartlog.log"
fi
##################### Variables Section Start #####################
if [[ "${TERM/term}" = "$TERM" ]]; then
COLUMNS=50
else
COLUMNS=$(tput cols)
fi

MACHINE_HOME="$CURRENT_DIR/predix-scripts/bash/PredixMachine"
COMPILE_REPO=0

export COLUMNS
##################### Variables Section End   #####################
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
arguments="$*"
echo "Arguments $arguments"
echo "$CURRENT_DIR"

rm -rf predix-scripts
rm -rf predix-machine-templates

if [ -d "predix-scripts" ]; then
 cd predix-scripts
 git pull
 cd ..
else
 __echo_run git clone https://github.com/PredixDev/predix-scripts.git
fi

__print_center "Creating Cloud Services" "#"

cd $CURRENT_DIR/predix-scripts
source bash/readargs.sh
source bash/scripts/files_helper_funcs.sh
if [[ ( "$RELEASE_TAG_VERSION" != "") ]]; then
	git stash
	__checkoutTags "predix-scripts" "$RELEASE_TAG_VERSION"
 fi


cd $CURRENT_DIR/predix-scripts/bash

if type dos2unix >/dev/null; then
find . -name "*.sh" -exec dos2unix -q {} \;
fi

#Run the quickstart
if [[ $SKIP_SERVICES -eq 0 ]]; then
__echo_run ./quickstart.sh -cs -mc -if $arguments
else
__echo_run ./quickstart.sh -mc -p $arguments
fi

cd "$CURRENT_DIR"

__print_center "Build and setup the Predix Machine Adapter for Intel Device" "#"

__echo_run cp "$CURRENT_DIR/config/com.ge.predix.solsvc.workshop.adapter.config" "$MACHINE_HOME/configuration/machine"
__echo_run cp "$CURRENT_DIR/config/com.ge.predix.workshop.nodeconfig.json" "$MACHINE_HOME/configuration/machine"
__echo_run cp "$CURRENT_DIR/config/com.ge.dspmicro.hoover.spillway-0.config" "$MACHINE_HOME/configuration/machine"
if [[ -f $CURRENT_DIR/config/setvars.sh ]]; then
	__echo_run cp "$CURRENT_DIR/config/setvars.sh" "$MACHINE_HOME/machine/bin/predix/setvars.sh"
fi

#Replace the :TAE tag with instance prepender
configFile="$MACHINE_HOME/configuration/machine/com.ge.predix.workshop.nodeconfig.json"
__find_and_replace ":TAE" ":$(echo $INSTANCE_PREPENDER | tr 'a-z' 'A-Z')" "$configFile" "$quickstartLogDir"
cd predix-scripts/bash
./scripts/buildMavenBundle.sh "$MACHINE_HOME"
cd ../..
