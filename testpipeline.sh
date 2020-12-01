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
	
	git_repo_name=$(echo $git_repo | cut -d'/' -f 2)
	git_branch=$(echo $git_ref | cut -d'/' -f 3)
	
	echo $git_api_url
	echo $git_owner
	echo $git_repo
	echo $git_repo_name
	echo $git_ref
	echo $git_branch
	
	for i in "$@"; do
        case "$i" in
        --IO.url=*) url="${i#*=}" ;;
        --IO.token=*) authtoken="${i#*=}" ;;
        --workflow.url=*) workflow_url="${i#*=}" ;;
        --workflow.token=*) workflow_token="${i#*=}" ;;
        --workflow.template=*) workflow_file="${i#*=}" ;;
        --slack.channel.id=*) slack_channel_id="${i#*=}" ;;    #slack
        --slack.token=*) slack_token="${i#*=}" ;;
        --jira.project.key=*) jira_project_key="${i#*=}" ;;    #jira
        --jira.assignee=*) jira_assignee="${i#*=}" ;;
        --jira.url=*) jira_server_url="${i#*=}" ;;
        --jira.username=*) jira_username="${i#*=}" ;;
        --jira.token=*) jira_auth_token="${i#*=}" ;;
        --bitbucket.workspace.name=*) bitbucket_workspace_name="${i#*=}" ;;    #bitbucket
        --bitbucket.repository.name=*) bitbucket_repo_name="${i#*=}" ;;
        --bitbucket.commit.id=*) bitbucket_commit_id="${i#*=}" ;;
        --bitbucket.username=*) bitbucket_username="${i#*=}" ;;
        --bitbucket.password=*) bitbucket_password="${i#*=}" ;;
        --github.owner.name=*) github_owner_name="${i#*=}" ;;         #github
        --github.repository.name=*) github_repo_name="${i#*=}" ;;
        --github.ref=*) github_ref="${i#*=}" ;;
        --github.commit.id=*) github_commit_id="${i#*=}" ;;
        --github.username=*) github_username="${i#*=}" ;;
        --github.token=*) github_access_token="${i#*=}" ;;
        --IS_SAST_ENABLED=*) is_sast_enabled="${i#*=}" ;;             #polaris
        --polaris.project.name=*) polaris_project_name="${i#*=}" ;;
        --polaris.url=*) polaris_server_url="${i#*=}" ;;
        --polaris.token=*) polaris_access_token="${i#*=}" ;;
        --IS_SCA_ENABLED=*) is_sca_enabled="${i#*=}" ;;                 #blackduck
        --blackduck.project.name=*) blackduck_project_name="${i#*=}" ;;
        --blackduck.url=*) blackduck_server_url="${i#*=}" ;;
        --blackduck.api.token=*) blackduck_access_token="${i#*=}" ;;
        *) ;;
        esac
    done
	
	io_manifest=$(cat synopsys-io.yml |
		sed " s~<<SLACK_CHANNEL_ID>>~$slack_channel_id~g; \
	    s~<<SLACK_TOKEN>>~$slack_token~g; \
	    s~<<JIRA_PROJECT_KEY>>~$jira_project_key~g; \
	    s~<<JIRA_ASSIGNEE>>~$jira_assignee~g; \
	    s~<<JIRA_SERVER_URL>>~$jira_server_url~g; \
	    s~<<JIRA_USERNAME>>~$jira_username~g; \
	    s~<<JIRA_AUTH_TOKEN>>~$jira_auth_token~g; \
	    s~<<BITBUCKET_WORKSPACE_NAME>>~$bitbucket_workspace_name~g; \
	    s~<<BITBUCKET_REPO_NAME>>~$bitbucket_repo_name~g; \
	    s~<<BITBUCKET_COMMIT_ID>>~$bitbucket_commit_id~g; \
	    s~<<BITBUCKET_USERNAME>>~$bitbucket_username~g; \
	    s~<<BITBUCKET_PASSWORD>>~$bitbucket_password~g; \
	    s~<<GITHUB_OWNER_NAME>>~$github_owner_name~g; \
	    s~<<GITHUB_REPO_NAME>>~$github_repo_name~g; \
	    s~<<GITHUB_REF>>~$github_ref~g; \
	    s~<<GITHUB_COMMIT_ID>>~$github_commit_id~g; \
	    s~<<GITHUB_USERNAME>>~$github_username~g; \
	    s~<<GITHUB_ACCESS_TOKEN>>~$github_access_token~g; \
	    s~<<IS_SAST_ENABLED>>~$is_sast_enabled~g; \
	    s~<<POLARIS_PROJECT_NAME>>~$polaris_project_name~g; \
	    s~<<POLARIS_SERVER_URL>>~$polaris_server_url~g; \
	    s~<<POLARIS_ACCESS_TOKEN>>~$polaris_access_token~g; \
	    s~<<IS_SCA_ENABLED>>~$is_sca_enabled~g; \
	    s~<<BLACKDUCK_PROJECT_NAME>>~$blackduck_project_name~g; \
	    s~<<BLACKDUCK_SERVER_URL>>~$blackduck_server_url~g; \
	    s~<<BLACKDUCK_ACCESS_TOKEN>>~$blackduck_access_token~g; \
	    s~<<BLACKDUCK_SERVER_URL>>~$blackduck_server_url~g; \
	    s~<<APP_ID>>~$git_repo~g; \
	    s~<<ASSET_ID>>~$git_repo~g; \
	    s~<<SCM_TYPE>>~github~g; \
	    s~<<REPO_OWNER_NAME>>~$git_owner~g; \
	    s~<<REPO_NAME>>~$git_repo_name~g; \
	    s~<<BRANCH_REF>>~$git_branch~g")
    
    # apply the yml with the substituted value
    echo "$io_manifest" >synopsys-io.yml
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
