#!/bin/bash

################################################################################
# function to list and run another script with the pause routine in it.
################################################################################
function runit() {
  if [ -x "$1" ]; then
    echo "##### About to run script: $1"
    ./pause.sh
    ./$1 $2 $3 $4
  else
    echo "##### Not able to run script: $1"
  fi
}

################################################################################
# main
################################################################################

if [ "$INSTALL_MODULES" = 'y' ]; then
  say Installing and configuring modules needed for citynet or sandiego migrations
  echo 'NOTE: The list of modules has not been updated since jan 2020, ' 
  echo ' To update the list of modules, 
 export a TSV from "Compare Module Updates.numbers" that is located in documentation directory, 
 then proceed'
  runit generate-require-enable-scripts.sh
  echo 'Require all the modules that will be needed for sandiego.gov'
  runit req.sh
  echo 'Enable all the modules that will be needed for sandiego.gov (list generated FROM SPEADSHEET)'
  runit en.sh
  echo 'Enable ADDITION the modules that will be needed for sandiego.gov (added manually)'
  runit en-more.sh
  echo 'Configure certain modules'
  runit configure-modules.sh
  echo 'Require and enable DEV and specific versions'
  runit dev.sh
  echo 'Add in patches'
  runit patches.sh
fi


echo "clearing Drupal 8 (${DRUPAL8_DB}) cache"
cd $DRUPAL8_DIR
drush cr
cd -

echo "save off ${DRUPAL8_DB} site so we can more quickly redo to ${OVERLORD_DIR}/${DRUPAL8_DB}.tar.gz"
runit drupal8-save.sh

echo 'DONE'
say Done with Migration setup

