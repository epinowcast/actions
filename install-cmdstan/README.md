# Install CmdStan GitHub Action

This action installs and caches [CmdStan](https://mc-stan.org/users/interfaces/cmdstan), allowing specification of version and number of cores for building. It uses [`{cmdstanr}`](https://github.com/stan-dev/cmdstanr) to function and hence depends on `{cmdstanr}` and R. If these dependencies are not installed it will install them.

## Inputs

### `cmdstan-version`

**Optional** The version of CmdStan to install. Default `"latest"`.

### `num-cores`

**Optional** Number of cores to use for building. Default `1`.

### `github-token`

**Optional** The GitHub token used to create an authenticated client. By default
will use one automatically created by the github action.

## Example usage

```yaml
- name: Install cmdstan
  uses: epinowcast/actions/install-cmdstan@v1
  with:
    cmdstan-version: 'latest'
    num-cores: 2
```
