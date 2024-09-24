# Install CmdStan GitHub Action

This action installs and caches [CmdStan](https://mc-stan.org/users/interfaces/cmdstan), allowing specification of version and number of cores for building. It uses [`{cmdstanr}`](https://github.com/stan-dev/cmdstanr) to function and hence depends on `{cmdstanr}` and R.

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
- name: Set up R
  uses: r-lib/actions/setup-r@v2

- name: Install cmdstanr
  run: |
    install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))
  shell: Rscript {0}

- name: Install cmdstan
  uses: epinowcast/actions/install-cmdstan@v1
  with:
    cmdstan-version: 'latest'
    num-cores: 2
```
