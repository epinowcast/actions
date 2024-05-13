#!/bin/bash

# Detect the operating system and install jq
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update
    sudo apt-get install -y jq
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install jq
else
    echo "Unsupported OS for this script"
    exit 1
fi

# Function to get the latest CmdStan version using GitHub API
get_latest_version() {
    local retries=3
    local wait_time=5
    local status=0
    local version=""

    for ((i=0; i<retries; i++)); do
        echo "Attempt $((i+1)) of $retries"
        response=$(curl -s -w "%{http_code}" -o temp.json https://api.github.com/repos/stan-dev/cmdstan/releases/latest)
        http_code=$(tail -n1 temp.json)
        version=$(jq -r '.tag_name' temp.json | tr -d 'v')
        rm temp.json
        status=$?
        echo "HTTP status code: $http_code"
        echo "Curl exit status: $status"
        echo "Fetched version: $version"
    
        if [[ $http_code == 200 ]] && [ -n "$version" ]; then
            echo "Successfully fetched version: $version"
            return 0
        else
            echo "Failed to fetch version or bad HTTP status. HTTP status: $http_code, Version fetched: '$version'"
        fi
    
        sleep $wait_time
        echo "Sleeping for $wait_time seconds before retrying..."
        wait_time=$((wait_time*2))
    done
    
    echo "Failed to fetch the latest CmdStan version after $retries attempts."
    return 1
}

# Fetch the latest release version of CmdStan
version=$(get_latest_version)

if [ $? -ne 0 ] || [ -z "$version" ]; then
    echo "Failed to fetch the latest CmdStan version"
    exit 1
fi

# Pass the version to the GitHub environment
echo "CMDSTAN_VERSION=$version" >> $GITHUB_ENV

echo "CmdStan latest version: $version"
