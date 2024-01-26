const core = require('@actions/core');
const cache = require('@actions/cache');
const exec = require('@actions/exec');
const axios = require('axios');

async function run() {
  try {
    let cmdstanVersion = core.getInput('cmdstan-version');

    if (cmdstanVersion === 'latest') {
      const response = await axios.get('https://api.github.com/repos/stan-dev/cmdstan/releases/latest');
      cmdstanVersion = response.data.tarball_url.split('/').pop().split('v').pop();
    }

    const cmdstanPath = process.env['HOME'] + '/.cmdstan';
    const cacheKey = `cmdstan-${cmdstanVersion}`;

    let cacheHit = await cache.restoreCache([cmdstanPath], cacheKey);

    if (!cacheHit) {
      const numCores = core.getInput('num-cores');
      await exec.exec(`bash ${__dirname}/install_cmdstan_script.sh`, [cmdstanVersion, cmdstanPath, numCores]);
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

run();
