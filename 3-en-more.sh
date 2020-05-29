#!/bin/bash
[ "$PEEK" == '1' ] && set -x
[ "$PEEK" == '2' ] && set -xv

echo 'enable more modules that were not automatically enabled or we want to test'
drush -y en devel webform_ui webform_node

echo 'must enable themes differently'
drush theme:enable adminimal_theme

echo 'enable easy_install to allow removal of config for disabled module (custom, etc)'
drush -y en easy_install

drush -y config:set system.theme admin adminimal_theme

echo 'Add option to run PHP in devel GUI'
composer -v require drupal/devel_php
drush en devel_php

echo 'Changing requirements for symfony/event-dispatcher to allow update solarium for search_api. See: https://www.drupal.org/project/search_api_solr/issues/3085196'
composer require symfony/event-dispatcher:"4.3.11 as 3.4.35"

echo 'Add patches to composer.json if not already in there, then run composer update'

echo 'Must add patch plugin first'
composer require cweagans/composer-patches


  echo 'MUST DO THIS MANUALLY BECAUSE SOME THINGS NOT THERE !??! Updating the composer.json file with patches'

  sed -i '.bk.patches' 's#"extra": {#&\
        "enable-patching": true,\
        "composer-exit-on-patch-failure": true,\
        "patches": {\
          "drupal/views_url_alias": {\
            "Patch for Drupal 8.8" : "https://www.drupal.org/files/issues/2020-01-13/3104606-15.patch"\
          },\
          "drupal/insert_block": {\
            "Make insert_block filter visible" : "https://www.drupal.org/files/issues/2018-06-08/2648496-46.patch"\
          }\
        },#' composer.json

  composer update
  echo 'before the composer update command did not update insert_block, so do it specifically'
  composer update drupal/insert_block
  drush cr
