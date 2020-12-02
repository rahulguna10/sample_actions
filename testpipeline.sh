#!/bin/bash

run()
{  
    echo "Getting values from Github Actions"
	
    github_owner_name=$(echo $GITHUB_ACTOR)
    github_repo=$(echo $GITHUB_REPOSITORY)
    github_repo_name=$(echo $github_repo | cut -d'/' -f 2)
    github_ref=$(echo $GITHUB_REF)
	
    #variables needed to generate the YAML file
    asset_id=$github_repo
    scm_type=github
    repo_owner_name=$github_owner_name
    repo_name=$github_repo_name
    branch_name=$(echo $github_ref | cut -d'/' -f 3)  
    
    echo "----------initial ----------"
    echo $github_ref
    
    echo "--------- Needed --------------"
    echo "$asset_id"
    echo "$scm_type"
    echo "$repo_owner_name"
    echo "$repo_name"
    echo "$branch_name"
    
    echo "------------ Additional -----------"
    echo $GITHUB_EVENT_NAME
    echo $GITHUB_HEAD_REF
    echo $GITHUB_BASE_REF
}
ARGS=("$@")

run
