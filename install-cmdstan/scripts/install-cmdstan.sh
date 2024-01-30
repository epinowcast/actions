#!/bin/bash

version=$1
num_cores=$2


# Set path to that expected by CmdStan
cmdstan_dir="$HOME/.cmdstan/cmdstan-${version}"

# Install CmdStan
mkdir -p "$cmdstan_dir"
cd "$cmdstan_dir" || exit
wget "https://github.com/stan-dev/cmdstan/releases/download/v${version}/cmdstan-${version}.tar.gz"
tar -xzf "cmdstan-${version}.tar.gz"
cd "cmdstan-${version}" || exit
make build -j${num_cores}
