#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#######Functions
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
#######Functions end##########
arguments="$*"
if [ -d "predix-scripts" ]; then
 cd predix-scripts
 git pull
 cd ..
else
 __echo_run git clone https://github.com/PredixDev/predix-scripts.git -b develop
fi

__print_center "Creating Machine Container" "#"

source predix-scripts/bash/readargs.sh -cm $arguments
source predix-scripts/bash/scripts/files_helper_funcs.sh

if type dos2unix >/dev/null; then
find predix-scripts -name "*.sh" -exec dos2unix -q {} \;
fi
cd predix-scripts/bash

./quickstart.sh -cm $arguments

cd $CURRENT_DIR/..
pwd
