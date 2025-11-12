# terraform-aws-vpc-connectivity

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tedilabs/terraform-aws-vpc-connectivity?color=blue&sort=semver&style=flat-square)
![GitHub](https://img.shields.io/github/license/tedilabs/terraform-aws-vpc-connectivity?color=blue&style=flat-square)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

Terraform module which creates VPC Connectivity related resources (DX, VPC Lattice) on AWS.

- [dx-connection](./modules/dx-connection)
- [dx-gateway](./modules/dx-gateway)
- [dx-private-virtual-interface](./modules/dx-private-virtual-interface)
- [lattice-alb-target-group](./modules/lattice-alb-target-group)
- [lattice-instance-target-group](./modules/lattice-instance-target-group)
- [lattice-ip-target-group](./modules/lattice-ip-target-group)
- [lattice-lambda-target-group](./modules/lattice-lambda-target-group)
- [lattice-service-listener](./modules/lattice-service-listener)
- [lattice-service-network](./modules/lattice-service-network)
- [lattice-service](./modules/lattice-service)
- [lattice-shared-service-network](./modules/lattice-shared-service-network)
- [lattice-shared-service](./modules/lattice-shared-service)
- [reachability-analyzer-path](./modules/reachability-analyzer-path)


## Target AWS Services

Terraform Modules from [this package](https://github.com/tedilabs/terraform-aws-vpc-connectivity) were written to manage the following AWS Services with Terraform.

- **AWS VPC Lattice**
  - Service Network
  - Service Listener
  - Service
  - Target Group
    - ALB Target Group
    - Instance Target Group
    - IP Target Group
    - Lambda Target Group
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

### VPC Lattice

- [lattice-service-network-simple](./examples/lattice-service-network-simple)
- [lattice-alb-target-group](./examples/lattice-alb-target-group)
- [lattice-instance-target-group](./examples/lattice-instance-target-group)
- [lattice-ip-target-group](./examples/lattice-ip-target-group)
- [lattice-lambda-target-group](./examples/lattice-lambda-target-group)

### Network Manager

- [reachability-analyzer](./examples/reachability-analyzer)


## Self Promotion

Like this project? Follow the repository on [GitHub](https://github.com/tedilabs/terraform-aws-vpc-connectivity). And if you're feeling especially charitable, follow **[posquit0](https://github.com/posquit0)** on GitHub.


## License

Provided under the terms of the [Apache License](LICENSE).

Copyright © 2023-2025, [Byungjin Park](https://www.posquit0.com).
