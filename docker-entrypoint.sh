#!/bin/bash

# Ensure all gems installed. Add binstubs to bin which has been added to PATH in Dockerfile
# bundle binstubs bundler --force
bundle config --global github.https true
bundle check || bundle install --binstubs="$BUNDLE_BIN"

# Call command issued to the docker service
exec "$@"
