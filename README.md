# terraform-aws-vpc-connectivity

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tedilabs/terraform-aws-vpc-connectivity?color=blue&sort=semver&style=flat-square)
![GitHub](https://img.shields.io/github/license/tedilabs/terraform-aws-vpc-connectivity?color=blue&style=flat-square)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

Terraform module which creates VPC Connectivity related resources (DX) on AWS.

- [dx-connection](./modules/dx-connection)
- [dx-gateway](./modules/dx-gateway)
- [dx-private-virtual-interface](./modules/dx-private-virtual-interface)
- [reachability-analyzer-path](./modules/reachability-analyzer-path)


## Target AWS Services

Terraform Modules from [this package](https://github.com/tedilabs/terraform-aws-vpc-connectivity) were written to manage the following AWS Services with Terraform.

- **AWS DX (Direct Connect)**
  - Connection
  - Gateway
  - Virtual Interface
    - Private Virtual Interface
- **AWS Network Manager**
  - Reachability Analyzer
    - Path
    - Analysis


## Examples

### Network Manager

- [reachability-analyzer](./examples/reachability-analyzer)


## Self Promotion

Like this project? Follow the repository on [GitHub](https://github.com/tedilabs/terraform-aws-vpc-connectivity). And if you're feeling especially charitable, follow **[posquit0](https://github.com/posquit0)** on GitHub.


## License

Provided under the terms of the [Apache License](LICENSE).

Copyright © 2023-2026, [Byungjin Park](https://www.posquit0.com).