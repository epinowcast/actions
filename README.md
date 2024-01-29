# GitHub Actions for the epinowcast community

This repository hosts a collection of GitHub Actions developed by and for the epinowcast community. These actions are designed to streamline and automate various aspects of software development, CI/CD pipelines, and workflow optimizations.

## Actions in this Repository

Below is a list of the available actions in this repository, along with a brief description of each. For detailed usage instructions, please refer to the individual README files in each action's directory.

### 1. Install and cache CmdStan (`install-cmdstan`)

This action installs and caches CmdStan. It allows specifying a version of CmdStan and supports using multiple cores for installation. It is adaptable for both Linux/Mac and Windows runners.

- [`install-cmdstan`](install-cmdstan/README.md)

## Using the Actions

To use any of these actions in your workflows, reference them with the following syntax:

```yaml
uses: epinowcast/actions/<action-directory>@<tag>
```

For example:

```yaml
uses: epinowcast/actions/install-cmdstan@v1
```

## Contributing

We welcome contributions to improve the actions in this repository. Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute.

## License

This repository and its actions are licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
