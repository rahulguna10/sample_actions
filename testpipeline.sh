#!/bin/bash

run()
{  
   curr_date=$(date +'%Y-%m-%d')
   
   github_file=.github/workflows/
   bitbucket_file=bitbucket-pipelines.yml
   
   if [ -a "$github_file" ]; then
   	echo "$github_file exists."
   	github_pipeline
   elif [ -f "$bitbucket_file" ]; then
   	echo "$bitbucket_file exists."
   	bitbucket_pipeline
   fi
}

function github_pipeline () {
	echo "Setting up synopsys-io.yml for Github Actions"
	wget https://sigdevsecops.blob.core.windows.net/intelligence-orchestration/2020.11/synopsys-io.yml
	
	git_api_url=$(echo $GITHUB_API_URL)
	git_owner=$(echo $GITHUB_ACTOR)
	git_repo=$(echo $GITHUB_REPOSITORY)
	git_ref=$(echo $GITHUB_REF)
	
	echo $git_api_url
	echo $git_owner
	echo $git_repo
	echo $git_ref
}

function bitbucket_pipeline () {
	echo "Setting up synopsys-io.yml for Bitbucket Pipelines"
}

function exit_program () {
    message=$1
    printf '\e[31m%s\e[0m\n' "$message"
    printf '\e[31m%s\e[0m\n' "Exited with error code 1"
    exit 1
}

ARGS=("$@")

run
