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
	echo %PATH%
	echo %GITHUB_WORKFLOW%
	echo %GITHUB_API_URL%
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
