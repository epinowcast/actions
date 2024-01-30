#!/bin/bash

# Fetch the latest release data from GitHub API
version=$(curl -s https://api.github.com/repos/stan-dev/cmdstan/releases/latest | awk -F '"' '/tag_name/{print $4}' | sed 's/^v//')

# Set the CMDSTAN_VERSION environment variable
echo "CMDSTAN_VERSION=$version" >> $GITHUB_ENV
