# PowerShell script to fetch the latest CmdStan release version

# Fetch the latest release data from the GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/stan-dev/cmdstan/releases/latest"

# Extract the version, removing the 'v' prefix if it exists
$version = $response.tag_name -replace '^v', ''

# Pass the version to the GitHub environment
"CMDSTAN_VERSION=$version" | Out-File -Append -FilePath $env:GITHUB_ENV

# Output the fetched version
Write-Host "CmdStan latest version: $version"
