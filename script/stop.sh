#!/bin/sh

# USAGE:
# ./stop.sh

PID_FILE="tmp/pids/unicorn.pid"

printf "Attempting to kill existing unicorn process..."
if [ -f $PID_FILE ];then
  kill -QUIT `cat $PID_FILE`
  rm -rf $PID_FILE
  echo "killed"
else
  echo "none found."
fi
