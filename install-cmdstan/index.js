const core = require('@actions/core');
const cache = require('@actions/cache');
const exec = require('@actions/exec');
const axios = require('axios');

async function run() {
  try {
    const cmdstanVersion = core.getInput('cmdstan-version') === 'latest'
      ? await getLatestCmdStanVersion()
      : core.getInput('cmdstan-version');
    const cmdstanPath = process.env['HOME'] + '/.cmdstan';
    const numCores = core.getInput('num-cores');
    const cacheKey = `cmdstan-${cmdstanVersion}`;
    const runnerOs = process.env['RUNNER_OS'];

    let cacheHit = await cache.restoreCache([cmdstanPath], cacheKey);

    if (!cacheHit) {
      if (runnerOs === 'Windows') {
        await exec.exec(`powershell ${__dirname}/install_cmdstan_win.ps1`, [cmdstanVersion, cmdstanPath, numCores]);
      } else {
        await exec.exec(`bash ${__dirname}/install_cmdstan_script.sh`, [cmdstanVersion, cmdstanPath, numCores]);
      }

      try {
        await cache.saveCache([cmdstanPath], cacheKey);
      } catch (error) {
        if (error.name !== cache.ValidationError.name && error.name !== cache.ReserveCacheError.name) {
          core.info(`[warning] ${error.message}`);
        }
      }
    } else {
      core.info(`Using cached CmdStan version ${cmdstanVersion}`);
    }

  } catch (error) {
    core.setFailed(error.message);
  }
}

async function getLatestCmdStanVersion() {
  const response = await axios.get('https://api.github.com/repos/stan-dev/cmdstan/releases/latest');
  return response.data.tarball_url.split('/').pop().split('v').pop();
}

run();
