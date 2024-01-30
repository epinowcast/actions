param (
    [string]$version,
    [int]$numCores = 1
)

# Define CmdStan directory path
$cmdstanDir = Join-Path $env:USERPROFILE ".cmdstan\cmdstan-$version"

# Create directory if it does not exist
if (-not (Test-Path $cmdstanDir)) {
    New-Item -ItemType Directory -Force -Path $cmdstanDir
}

# Change to the CmdStan path
Set-Location -Path $cmdstanDir

# Download CmdStan
$cmdstanUrl = "https://github.com/stan-dev/cmdstan/releases/download/v$version/cmdstan-$version.tar.gz"
$cmdstanTarGz = "cmdstan-$version.tar.gz"
Invoke-WebRequest -Uri $cmdstanUrl -OutFile $cmdstanTarGz

# Extract the tar.gz file
& tar -xzf $cmdstanTarGz

# Change to the CmdStan directory
Set-Location -Path "cmdstan-$version"

# Build CmdStan
& make -j$([int]$numCores) build
