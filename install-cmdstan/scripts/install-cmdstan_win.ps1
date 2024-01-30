param (
    [string]$version,
    [int]$numCores = 1
)

# Function to install Rtools and add its toolchain directories to the system PATH
function Install-Rtools {
    Write-Host "Checking for the latest version of Rtools..."

    # Define the URL to check for the latest Rtools version
    $rtoolsUrl = "https://cran.r-project.org/bin/windows/Rtools/"
    $pageContent = Invoke-WebRequest -Uri $rtoolsUrl -UseBasicParsing
    $latestRtools = ($pageContent.Links | Where-Object { $_.href -match 'rtools.*exe$' } | Select-Object -First 1).href
    if (-not $latestRtools) {
        Write-Host "Could not find the latest Rtools installer."
        exit 1
    }
    $rtoolsDownloadUrl = $rtoolsUrl + $latestRtools
    $rtoolsFileName = Split-Path -Leaf $rtoolsDownloadUrl

    Write-Host "Latest Rtools version found: $rtoolsFileName"
    Write-Host "Downloading Rtools from: $rtoolsDownloadUrl"

    # Define the installer path
    $installerPath = Join-Path $env:TEMP $rtoolsFileName
    if (-not (Test-Path $env:TEMP)) {
        New-Item -ItemType Directory -Force -Path $env:TEMP
    }

    # Download the latest Rtools installer
    try {
        Invoke-WebRequest -Uri $rtoolsDownloadUrl -OutFile $installerPath
    } catch {
        Write-Host "Failed to download Rtools: $_"
        exit 1
    }

    Write-Host "Installing Rtools..."
    try {
        Start-Process -FilePath $installerPath -Args '/VERYSILENT' -Wait
    } catch {
        Write-Host "Failed to install Rtools: $_"
        exit 1
    }

    Write-Host "Rtools has been installed."

    # Detect Rtools installation directory and add it to the system PATH
    $rtoolsDir = "C:\rtools" + $rtoolsFileName -replace 'rtools', '' -replace '.exe', ''
    $rtoolsUsrBinPath = Join-Path -Path $rtoolsDir -ChildPath "usr\bin"
    $rtoolsMingwBinPath = Join-Path -Path $rtoolsDir -ChildPath "mingw64\bin"
    Write-Host "Adding Rtools to system PATH: $rtoolsUsrBinPath and $rtoolsMingwBinPath"
    $env:PATH += ";$rtoolsUsrBinPath;$rtoolsMingwBinPath"
}

# Check if Rtools 'make' is on the system PATH
$makePath = (Get-Command make -ErrorAction SilentlyContinue).Source
if ($null -eq $makePath) {
    Write-Host "Rtools 'make' is not on the system PATH. Checking if Rtools is installed..."
    Install-Rtools
} else {
    Write-Host "Rtools is already installed and 'make' is on the system PATH."
}

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

# Build CmdStan using mingw32-make
& mingw32-make -j$([int]$numCores) build
