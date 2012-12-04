#!/bin/bash

# Script for RoR website deployment on Heroku
# Note that Heroku only supports Postgres databases
# Assumes that the Heroku tool is installed and the user is logged
# and the App is on github

# Arguments:
# $1 -> the store name
# $2 -> the repository ssh address
# $3 -> the custom domain, if wanted 

# Renames the directory if it already exists
if [ -d "$1" ]
then
	i=1
	while true
	do
		NEW_DIR=$1"_"$i
		if [ ! -d "$NEW_DIR" ]
		then 
			echo "$1 already exists. The folder will be renamed to $NEW_DIR"
			break
		fi
		i=$((i+1))
	done
else
	NEW_DIR=$1
fi

NUM_DYNOS=1
LOG_FILE=$NEW_DIR"_log.txt"

echo "Progress log can be checked in $LOG_FILE"

git clone $2 $NEW_DIR > $LOG_FILE

cd $NEW_DIR

# App creation on Heroku
# Missing app name availability check
heroku create $1 > $LOG_FILE

# Deploys the App on Heroku
git push heroku master > $LOG_FILE

# Scales the dyno run the webapp
heroku ps:scale web=$NUM_DYNOS > $LOG_FILE

# Adding a custom domain
# Assumes that the subdomain was already created in gandi.net

if [ ! -z "$3" ]
    then
		heroku domains:add $3 > $LOG_FILE
    else
		heroku domains:add "www.plazr.net/"$1 > $LOG_FILE
fi

echo "Setup of the $1 store is finished."

