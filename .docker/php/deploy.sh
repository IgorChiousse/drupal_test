#!/bin/bash

source .env

echo "***************************************"
echo "*             Start deploy            *"
echo "***************************************"

echo "1/9 - Clear cache..."
drush cr

echo "2/9 - Backup Database..."
drush sql-dump --result-file=/home/app/$PROJECT/dumps/$PROJECT_$(date +%F).sql

echo "3/9 - Mode maintenance ON..."
drush sset system.maintenance_mode 1
drush cr

echo "4/9 - Composer install..."
composer install --no-interaction

#echo "6/9 - NPM install and sass compile..."
#cd $THEME
#npm install
#./node_modules/.bin/sass sass/global.scss css/global.css
#cd /home/app/$PROJECT

if [ "$IMPORTDB" == "true" ]
then
  echo "4.5/9 - Import database from init dump..."
  drush sql-drop -y
  drush sqlq --file=/home/app/$PROJECT/init_database/init.sql.gz
fi

echo "5/9 - Update DB..."
drush updb -y
drush updb -y
drush cr

echo "6/9 - Config import..."
drush cim -y
drush cim -y
drush cr

echo "7/9 - Post-update DB..."
drush hook:deploy -y
drush hook:deploy -y
drush cr

echo "8/9 - Update translations..."
drush locale:check
drush locale:update


echo "9/9 - Mode maintenance OFF..."
drush sset system.maintenance_mode 0
drush cr

echo "***************************************"
echo "*              End deploy             *"
echo "***************************************"