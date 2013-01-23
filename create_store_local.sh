#!/bin/bash

# Script for RoR website deployment on a local machine
# Assumes that the store template is on github

# Arguments:
# $1 -> the store name
# $2 -> the store id

# The store directory
STORE_NAME=$2"_"$1
DIR="../plazr_stores/"$STORE_NAME
LOG_FILE=$DIR"/log.txt"
PORT=$((3000 + $2))
DEFAULT_REPO="git@github.com:Plazr/plazr_store_template.git"

#git clone $DEFAULT_REPO $DIR
mkdir $DIR
cp -R ../plazr_stores/plazr_store_template/* $DIR

#LOGO_PATH=$DIR"/public/assets/"$2"/logo"
#BANNER_PATH=$DIR"/public/assets/"$2"/banner"

#mkdir -pv $LOGO_PATH
#mkdir -pv $BANNER_PATH

#plazr/public/assets/stores/ID
#cp  "public/assets/images/"$2"/banner*" $BANNER_PATH
#cp  "public/assets/stores/"$2"/logo*" $LOGO_PATH

cd $DIR

echo 'name: '$1 >> config/config.yml

export BUNDLE_GEMFILE=$PWD"/Gemfile"

#bundle install 
#rake plazr_auth:install:migrations 
#rake plazr_store:install:migrations 
#rake db:migrate
rake store:create_yml[$2,$1]

rails server -d -e production -p $PORT

echo
echo "Setup of the $1 store is finished. Server is running in production on port $PORT"

