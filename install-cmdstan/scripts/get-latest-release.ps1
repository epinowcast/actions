# Fetch the latest release data from GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/stan-dev/cmdstan/releases/latest"
$version = $response.tag_name -replace '^v', ''

# Set the CMDSTAN_VERSION environment variable
echo "CMDSTAN_VERSION=$version" | Out-File -Append -FilePath $env:GITHUB_ENV
