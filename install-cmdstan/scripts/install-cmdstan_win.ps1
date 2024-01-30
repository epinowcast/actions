param (
    [string]$version,
    [int]$numCores = 1
)

# Function to install Rtools
function Install-Rtools {
    Write-Host "Checking for the latest version of Rtools..."

    # Define the URL to check for the latest Rtools version
    $rtoolsUrl = "https://cran.r-project.org/bin/windows/Rtools/"
    $pageContent = Invoke-WebRequest -Uri $rtoolsUrl -UseBasicParsing
    $latestRtools = ($pageContent.Links | Where-Object { $_.href -match 'rtools.*exe$' } | Select-Object -First 1).href
    $rtoolsDownloadUrl = $rtoolsUrl + $latestRtools

    Write-Host "Latest Rtools version found: $latestRtools"
    Write-Host "Downloading Rtools from: $rtoolsDownloadUrl"

    # Download the latest Rtools installer
    $installerPath = Join-Path $env:TEMP $latestRtools
    Invoke-WebRequest -Uri $rtoolsDownloadUrl -OutFile $installerPath

    Write-Host "Installing Rtools..."
    Start-Process -FilePath $installerPath -Args '/VERYSILENT' -Wait

    Write-Host "Rtools has been installed."
}

# Check if Rtools is on the system PATH by checking for the presence of directories starting with 'rtools'
$hasRtools = $false
foreach ($path in $env:PATH.Split(';')) {
    if ($path -match '\\rtools[0-9]+\\') {
        $hasRtools = $true
        break
    }
}
if (-not $hasRtools) {
    Write-Host "Rtools is not on the system PATH. Installing the latest version."
    Install-Rtools
} else {
    Write-Host "Rtools is already installed and on the system PATH."
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
