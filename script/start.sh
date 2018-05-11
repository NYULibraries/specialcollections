#!/bin/bash

# USAGE:
# ./start.sh {ENVIRONMENT}

# Stop existing process first, if any
./script/stop.sh $1

echo "Starting up unicorn..."
bundle exec unicorn -c config/unicorn/config.rb -E $2
