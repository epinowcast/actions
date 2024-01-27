param (
    [string]$version,
    [int]$numCores = 1
)

function Install-CmdStan {
    $cmdstanPath = ".cmdstan"
    $cmdstanUrl = "https://github.com/stan-dev/cmdstan/releases/download/v$version/cmdstan-$version.tar.gz"
    $cmdstanTarGz = "cmdstan-$version.tar.gz"
    $cmdstanDir = "cmdstan-$version"

    # Create directory if it does not exist
    if (-not (Test-Path $cmdstanPath)) {
        New-Item -ItemType Directory -Force -Path $cmdstanPath
    }

    # Change to the CmdStan path
    Set-Location -Path $cmdstanPath

    # Download CmdStan
    Invoke-WebRequest -Uri $cmdstanUrl -OutFile $cmdstanTarGz

    # Extract the tar.gz file
    & tar -xzf $cmdstanTarGz

    # Change to the CmdStan directory
    Set-Location -Path $cmdstanDir

    # Build CmdStan
    & make -j$numCores build
}

# Run the install function
Install-CmdStan
