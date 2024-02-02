#!/bin/sh -e

# assumed location from ead_indexer
EAD_DIR="$PWD/findingaids_eads"
# fabify any files changed in last commit
EAD_LIST=$(git -C $EAD_DIR diff --name-only HEAD HEAD~1)
for ead in $EAD_LIST
do
  ead_path="$EAD_DIR/$ead"
  if [ -f "$ead_path" ]; then
    echo "Fabifying EAD=$ead"
    tmp_ead_path="$ead-tmp"
    ./bin/nyudlts/dlts-finding-aids-fasb/fasb fabify ead $ead_path > $tmp_ead_path
    mv $tmp_ead_path $ead_path
  else
    echo "Skipping EAD $ead since it does not exist at $ead_path: deletion?"
  fi
done
# ead_indexer gathers files changed from commit; knows how to read deletions
bundle exec rake ead_indexer:reindex_changed
