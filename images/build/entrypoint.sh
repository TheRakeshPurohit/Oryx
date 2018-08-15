#!/bin/bash

if [ -n "$NODE" ]; then
  if [ ! -d "/opt/nodejs/$NODE" ]; then
    echo >&2 error: node version \'$NODE\' was not found
    exit 1
  fi
  NODE_BIN=/opt/nodejs/$NODE/bin
  export PATH=$NODE_BIN:$PATH
  export NODE=$NODE_BIN/node
  export NPM=$NODE_BIN/npm
  if [ -e "$NODE_BIN/npx" ]; then
    export NPX=$NODE_BIN/npx
  fi
fi
IFS='='
while read name value; do
  name=${name:5}
  if [ ! -d "/opt/nodejs/$value" ]; then
    echo >&2 error: node version \'$value\' was not found
    exit 1
  fi
  NODE_BIN=/opt/nodejs/$value/bin
  eval export NODE_$name=$NODE_BIN/node
  eval export NPM_$name=$NODE_BIN/npm
  eval export NPX_$name=$NODE_BIN/npx
done < <(env | grep ^NODE_)
IFS=$' \t\n'

if [ -n "$PYTHON" ]; then
  if [ ! -d "/opt/python/$PYTHON" ]; then
    echo >&2 error: python version \'$PYTHON\' was not found
  fi
  PYTHON_BIN=/opt/python/$PYTHON/bin
  export PATH=$PYTHON_BIN:$PATH
  export PIP=$PYTHON_BIN/pip
  if [ -e "$PYTHON_BIN/python2" ]; then
    export PYTHON=$PYTHON_BIN/python2
  elif [ -e "$PYTHON_BIN/python3" ]; then
    export PYTHON=$PYTHON_BIN/python3
  fi
  if [ -e "$PYTHON_BIN/virtualenv" ]; then
    export VIRTUALENV=$PYTHON_BIN/virtualenv
  fi
fi
IFS='='
while read name value; do
  name=${name:7}
  if [ ! -d "/opt/python/$value" ]; then
    echo >&2 error: python version \'$value\' was not found
    exit 1
  fi
  PYTHON_BIN=/opt/python/$value/bin
  eval export PIP_$name=$PYTHON_BIN/pip
  if [ -e "$PYTHON_BIN/python2" ]; then
    eval export PYTHON_$name=$PYTHON_BIN/python2
  elif [ -e "$PYTHON_BIN/python3" ]; then
    eval export PYTHON_$name=$PYTHON_BIN/python3
  fi
  if [ -e "$PYTHON_BIN/virtualenv" ]; then
    eval export VIRTUALENV_$name=$PYTHON_BIN/virtualenv
  fi
done < <(env | grep ^PYTHON_)
IFS=$' \t\n'

exec "$@"