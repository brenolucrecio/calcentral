#!/bin/bash
# Script to run capistrano

cd $( dirname "${BASH_SOURCE[0]}" )/..

# Enable rvm and use the correct Ruby version and gem set.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
source .rvmrc

export RAILS_ENV=${RAILS_ENV:-production}
export LOGGER_STDOUT=only
export JRUBY_OPTS="--dev"

echo "------------------------------------------"
echo "`date`: Redeploying CalCentral on app nodes..."

echo "`date`: cap calcentral_dev:colddeploy..."
cap -l STDOUT calcentral_dev:colddeploy || { echo "ERROR: capistrano deploy failed" ; exit 1 ; }
