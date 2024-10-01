const { execSync } = require('child_process');

function getLatestRelease() {
  const command = `gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    repos/stan-dev/cmdstan/releases/latest`;

  const output = execSync(command, { encoding: 'utf-8' });
  const release = JSON.parse(output);
  let version = release.tag_name.replace(/^v/, '');

  console.error(`Latest CmdStan version: ${version}`);
  // Set environment variable
  console.log(`CMDSTAN_VERSION=${version}`);
}

getLatestRelease();
