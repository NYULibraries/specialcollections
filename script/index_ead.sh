#!/bin/sh -e

# assumed location from ead_indexer
EAD_DIR="$PWD/findingaids_eads"
# check that specified ead file exists
ead_path="$EAD_DIR/$1"
if ![ -f "$ead_path" ]; then
  echo "Cannot index EAD=$1 since it does not exist at $ead_path"
  exit 1
fi
# fabify 
echo "Fabifying EAD=$1"
tmp_ead_path="$1-tmp"
./bin/nyudlts/dlts-finding-aids-fasb/fasb fabify ead $ead_path > $tmp_ead_path
mv $tmp_ead_path $ead_path
# index
bundle exec rake ead_indexer:index EAD=$1
