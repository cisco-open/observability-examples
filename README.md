# Cisco Observability Platform Examples

[![Lint](https://github.com/cisco-open/observability-examples/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/cisco-open/observability-examples/actions/workflows/lint.yml)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-fbab2c.svg)](CODE_OF_CONDUCT.md)
[![Maintainer](https://img.shields.io/badge/Maintainer-Cisco-00bceb.svg)](https://opensource.cisco.com)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/cisco-open/observability-examples/badge)](https://securityscorecards.dev/viewer/?uri=github.com/cisco-open/observability-examples)

Cisco Observability Platform is an extensible platform for all applications of
observability. This repository contains examples of how to build solutions using
core features of the platform like entity modeling, data ingestion, processing
and visualization using dashboards.

## Getting Started

Each directory in examples contains a solution example. Each example has its own
README.md file that describes the example and how to run it.

To set up the environment for running the examples, follow the instructions
below.

## Prerequisites

### Installation

- brew

  Install [Homebrew](https://brew.sh) if not already installed.

- fsoc

  ```sh
  brew install cisco-open/tap/fsoc
  ```

- jq

  ```sh
  brew install jq
  ```

- Clone the repo

   ```sh
   git clone https://github.com/cisco-open/observability-examples.git
   ```


### Configure FSOC CLI

Set up your FSOC CLI to point to the Cisco Observability Platform and configure
your credentials.
```$ fsoc config set auth=oauth url=https://<mytenant>.observe.appdynamics.com```
The URL should point to your tenant.

Validate configuration

```$ fsoc login
Login completed successfully.
```

Refer to the [FSOC CLI documentation](https://github.com/cisco-open/fsoc) for
more options to configure the FSOC CLI.

### Validation

[Configure fsoc to use your Cisco Observability Platform tenant](https://github.com/cisco-open/fsoc#Configure)

```shell
make integration_test
```

## Roadmap

See
the [open issues](https://github.com/cisco-open/observability-examples/issues)
for a list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to
learn, inspire, and create. Any contributions you make are **greatly appreciated
**. For detailed contributing guidelines, please
see [CONTRIBUTING.md](CONTRIBUTING.md)

## License

Distributed under the `Apache Software License` License. See [LICENSE](LICENSE)
for more information.

## Contact

For all project feedback, please
use [Github Issues](https://github.com/cisco-open/observability-examples/issues).
