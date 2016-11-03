#!/bin/bash
# Deploys a Vapor project to an EC2 instance
#
# run with ./deploy.sh SERVER_IP
# Example:
# ./deploy.sh ec2-12-34-456-890.compute-1.amazonaws.com

if [ "$1" == "" ]; then
    echo "ERROR: 1st parameter is missing. Should be USER@SERVER"
    exit
fi

ARCHIVE="/tmp/app.zip"
FOLDER="~/app"

echo "starting deployment to $1"

echo "zipping the project’s Git HEAD to $ARCHIVE"
git archive -o $ARCHIVE HEAD

echo "uploading to $1, please wait"
scp -r $ARCHIVE $1:/tmp/

echo "optionally (re)creating folder $FOLDER on server"
CMD="mkdir -p $FOLDER"
ssh $1 $CMD

echo "unzipping uploaded file to $FOLDER on server"
CMD="unzip -o -q $ARCHIVE -d $FOLDER"
ssh $1 $CMD

echo "deleting optionally existing .gitignore & .travis.yml on server"
CMD="cd $FOLDER && rm -f .gitignore* && rm -f .travis*"
ssh $1 $CMD

echo "building project, please wait"
CMD="cd $FOLDER && swift package update && vapor build --release"
ssh $1 "bash -lc \"$CMD\""

echo "restarting service"
CMD="sudo systemctl restart app"
ssh $1 $CMD

echo "service status:"
CMD="sudo systemctl status app"
ssh $1 $CMD

echo "Finished!"
