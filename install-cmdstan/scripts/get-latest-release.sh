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

# Fetch the latest release version of CmdStan
version=$(curl -s https://api.github.com/repos/stan-dev/cmdstan/releases/latest | jq -r '.tag_name' | tr -d 'v')

# Pass the version to the GitHub environment
echo "CMDSTAN_VERSION=$version" >> $GITHUB_ENV

echo "CmdStan latest version: $version"
