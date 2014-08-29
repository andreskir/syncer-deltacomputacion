#!/bin/bash

# Exit if any command fails
set -e

if [ "$#" -ne 2 ]; then
	echo "Couldn't run script!"
	echo "Usage is: deploy_to_azure_websites.sh azureWebsiteName (staging|production) [commitMessage]"
	exit 1
fi

azureWebsiteName=$1
env=$2

if [ -z "$3" ]; then
	commitMessage="Deploy"
else
	commitMessage=$3
fi

if [ "$env" == "staging" ] ; then
	azureWebsiteFullName="$azureWebsiteName-staging"
else
	azureWebsiteFullName="$azureWebsiteName"
fi

echo "Starting deploy for $env environment!"
# git config --global user.email "ci@parsimotion.com"
# git config --global user.name "Semaphore CI"

echo "Installing dependencies..."
# bundle install
# npm install -g grunt-cli
# npm install
# bower install

echo "Running grunt deploy-$env..."
grunt

# Add git repo
rm -rf deploy
git clone https://andreskir:Parsi2014@$azureWebsiteFullName.scm.azurewebsites.net:443/$azureWebsiteName.git deploy
find deploy -mindepth 1 -not -path '*/.git*' -not -name '.htaccess' -not -name 'iisnode.yml' -not -name 'web.config' -exec rm {} \;
cp -r dist/* deploy

echo "Starting deploy to $azureWebsiteName..."

# Commit and push
cd deploy
git add -A .
git commit -m "$commitMessage"
git push --force origin master

echo "All done! You can check the new release at http://$azureWebsiteFullName.azurewebsites.net"
