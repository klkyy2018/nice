#!/bin/bash
dir=$(basename $(pwd))
if [[ ${dir} != "nice" ]]; then
  echo "this script must be executed at root directory of the repo"
  exit 1
fi
NICE_HOME=$(pwd)
mkdir -p ${NICE_HOME}/.git/hooks
ln -sf ${NICE_HOME}/funny_shell/git/pre-commit ${NICE_HOME}/.git/hooks/pre-commit
cd ${NICE_HOME} && git config core.hooksPath ${NICE_HOME}/.git/hooks
