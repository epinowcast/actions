# Install CmdStan GitHub Action

This action installs and caches CmdStan, allowing specification of version and number of cores for building.

## Inputs

### `cmdstan-version`

**Optional** The version of CmdStan to install. Default `"latest"`.

### `num-cores`

**Optional** Number of cores to use for building. Default `1`.

## Example usage

```yaml
uses: your-github-username/cmdstan-action-js@v1
with:
  cmdstan-version: 'latest'
  num-cores: 2
```
