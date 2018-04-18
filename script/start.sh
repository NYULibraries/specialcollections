#!/bin/bash

# USAGE:
# ./start.sh {ENVIRONMENT}

# Stop existing process first, if any
./script/stop.sh $1

echo "Starting up unicorn..."
if [ "$2" == "production" ]; then
  bundle exec unicorn -c config/unicorn/production.rb -E production
else
  bundle exec unicorn -c config/unicorn/development.rb
fi
