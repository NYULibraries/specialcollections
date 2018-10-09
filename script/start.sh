#!/bin/sh

# USAGE:
# ./start.sh {ENVIRONMENT}

# Stop existing process first, if any
./script/stop.sh

echo "Starting up unicorn..."
bundle exec unicorn -c config/unicorn/config.rb -E $1
