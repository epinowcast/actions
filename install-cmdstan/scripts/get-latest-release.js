const https = require('https');
const { execSync } = require('child_process');

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function getLatestRelease() {
  const retries = 10;
  let waitTime = 5000; // 5 seconds
  
  for (let i = 0; i < retries; i++) {
    console.log(`Attempt ${i + 1} of ${retries}`);
    
    try {
      const options = {
        hostname: 'api.github.com',
        path: '/repos/stan-dev/cmdstan/releases/latest',
        headers: {
          'User-Agent': 'Node.js',
          'Accept': 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28'
        }
      };

      if (process.env.GH_TOKEN) {
        options.headers['Authorization'] = `Bearer ${process.env.GH_TOKEN}`;
      } else {
        console.log("No authentication token found in the environment.");
      }

      const response = await new Promise((resolve, reject) => {
        https.get(options, (res) => {
          let data = '';
          res.on('data', (chunk) => data += chunk);
          res.on('end', () => resolve({ statusCode: res.statusCode, body: data }));
        }).on('error', reject);
      });

      console.log(`HTTP status code: ${response.statusCode}`);

      if (response.statusCode === 200) {
        const release = JSON.parse(response.body);
        const version = release.tag_name.replace(/^v/, '');
        console.log(`Successfully fetched version: ${version}`);
        console.log(`CMDSTAN_VERSION=${version}`);
        return;
      } else {
        console.log(`Failed to fetch version. HTTP status: ${response.statusCode}`);
      }
    } catch (error) {
      console.error(`Error occurred: ${error.message}`);
    }

    console.log(`Sleeping for ${waitTime / 1000} seconds before retrying...`);
    await sleep(waitTime);
    waitTime *= 2;
  }

  console.error("Failed to fetch the latest CmdStan version after 10 attempts.");
  process.exit(1);
}

getLatestRelease();
