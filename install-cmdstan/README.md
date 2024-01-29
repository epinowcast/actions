# Install CmdStan GitHub Action

This action installs and caches [CmdStan](https://mc-stan.org/users/interfaces/cmdstan), allowing specification of version and number of cores for building.

## Inputs

### `cmdstan-version`

**Optional** The version of CmdStan to install. Default `"latest"`.

### `num-cores`

**Optional** Number of cores to use for building. Default `1`.

## Example usage

```yaml
uses: epinowcast/actions/install-cmdstan@v1
with:
  cmdstan-version: 'latest'
  num-cores: 2
```
