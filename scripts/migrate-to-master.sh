#!/bin/bash
DIR=$(cd $(dirname $0) && pwd)

git checkout master
git merge develop -Xtheirs --no-commit

if [ $(uname) == "Darwin" ]; then
    sed -i "" -e "s/branch = develop/branch = master/g" .gitmodules
else
    sed -i -e "s/branch = develop/branch = master/g" .gitmodules
fi

git status
if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
    echo "Nothing to merge"
else
    git commit -a -m "Merge branch 'develop'"
    git push
fi
