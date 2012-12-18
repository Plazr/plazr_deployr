#!/bin/bash

# Script for RoR website deployment on Heroku
# Note that Heroku only supports Postgres databases
# Assumes that the Heroku tool is installed and the user is logged
# and the App is on github

# Arguments:
# $1 -> the store name
# $2 -> the store id
# $3 -> the custom domain, if wanted 

# The store directory
STORE_NAME=$2"_"$1
DIR="../plazr_stores/"$STORE_NAME
NUM_DYNOS=1
LOG_FILE="../plazr_stores/"$DIR"/log.txt"
DEFAULT_REPO="git@github.com:Plazr/plazr_store_template.git"

echo "Progress log can be checked in $LOG_FILE"

git clone $DEFAULT_REPO $DIR > $LOG_FILE

cd $DIR

# App creation on Heroku
# Missing app name availability check
heroku create $1 > $LOG_FILE

# Deploys the App on Heroku
git push heroku master > $LOG_FILE

# Scales the dyno run the webapp
heroku ps:scale web=$NUM_DYNOS > $LOG_FILE

# Adding a custom domain
# Create subdomain on Gandi.net and associates it to heroku
if [ ! -z "$3" ]
    then
		heroku domains:add $3 > $LOG_FILE
    else
		
		heroku domains:add "www.plazr.net/"$1 > $LOG_FILE
fi

echo "Setup of the $1 store is finished."

