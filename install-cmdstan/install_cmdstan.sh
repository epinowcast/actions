#!/bin/bash

version=$1
cmdstan_path=$2

# Install CmdStan
mkdir -p "${cmdstan_path}"
cd "${cmdstan_path}" || exit
wget "https://github.com/stan-dev/cmdstan/releases/download/${version}/cmdstan-${version}.tar.gz"
tar -xzf "cmdstan-${version}.tar.gz"
cd "cmdstan-${version}" || exit
make build
