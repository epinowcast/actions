#!/bin/bash

version=$1
num_cores=$2


# Install CmdStan
mkdir -p "cmdstan"
cd "cmdstan" || exit
wget "https://github.com/stan-dev/cmdstan/releases/download/v${version}/cmdstan-${version}.tar.gz"
tar -xzf "cmdstan-${version}.tar.gz"
cd "cmdstan-${version}" || exit
make build -j${num_cores}
