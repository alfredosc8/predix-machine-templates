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

export COLUMNS
##################### Variables Section End   #####################

##################### Functions Section Start   #####################
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
function getRepoURL {
	local  repoURLVar=$2
	reponame=$(echo "$1" | awk -F "/" '{print $NF}')
	url=$(echo "$a" | sed -n "/\"$reponame\"/p" $CURRENT_DIR/version.json | awk -F"\"" '{print $4}' | awk -F"#" '{print $1}')
	eval $repoURLVar="'$url'"
}
function getRepoVersion {
	local  repoVersionVar=$2
	reponame=$(echo "$1" | awk -F "/" '{print $NF}')
	repo_version="$(echo "$a" | sed -n "/\"$reponame\"/p" $CURRENT_DIR/version.json | awk -F"\"" '{print $4}' | awk -F"#" '{print $NF}')"
	eval $repoVersionVar="'$repo_version'"
}

function downloadDependencies {
  GITHUB_REPOS=$1
  ARRAY_REPOS=(${GITHUB_REPOS//,/ })
  rm -rf workspace
  for repo in "${ARRAY_REPOS[@]}"
  do
    echo $repo
    cd $CURRENT_DIR
    mkdir -p workspace
    cd workspace
    getRepoURL $repo repoURL
    getRepoVersion $repo repoVersion
    echo "$repoURL $repoVersion"
    git clone "$repoURL" -b "$repoVersion"
    cd $repo
    mvn clean dependency:copy
    PROJECT_ARTIFACT_ID=$(mvn org.apache.maven.plugins:maven-help-plugin:2.2:evaluate -Dexpression=project.artifactId | grep -e '^[^\[]')
    PROJECT_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.2:evaluate -Dexpression=project.version | grep -e '^[^\[]')
    MACHINE_BUNDLE="$PROJECT_ARTIFACT_ID-$PROJECT_VERSION.jar"
    cp target/$MACHINE_BUNDLE ../../edge_bundles
  done

}
##################### Functions Section End   #####################
arguments="$*"
echo "Arguments $arguments"
echo "$CURRENT_DIR"

EDGE_STARTER_REPOS="predix-machine-template-adapter-edison,predix-machine-template-adapter-intel,predix-machine-template-adapter-pi,predix-machine-template-adapter-pi-gpio,predix-machine-template-adapter-simulator"
downloadDependencies $EDGE_STARTER_REPOS
