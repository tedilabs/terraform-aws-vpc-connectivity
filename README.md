# terraform-aws-vpc-connectivity

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tedilabs/terraform-aws-vpc-connectivity?color=blue&sort=semver&style=flat-square)
![GitHub](https://img.shields.io/github/license/tedilabs/terraform-aws-vpc-connectivity?color=blue&style=flat-square)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

Terraform module which creates VPC Connectivity related resources (VPC Peering, VPC Private Link, Client VPN, Site-to-Site VPN, DX, VPC Lattice) on AWS.

- [dx-connection](./modules/dx-connection)
- [dx-gateway](./modules/dx-gateway)
- [dx-private-virtual-interface](./modules/dx-private-virtual-interface)
- [lattice-service-network](./modules/lattice-service-network)
- [lattice-service](./modules/lattice-service)
- [reachability-analyzer-path](./modules/reachability-analyzer-path)
- [vpc-endpoint-service](./modules/vpc-endpoint-service)
- [vpc-gateway-endpoint](./modules/vpc-gateway-endpoint)
- [vpc-interface-endpoint](./modules/vpc-interface-endpoint)
- [vpc-peering](./modules/vpc-peering)
- [vpc-peering-accepter](./modules/vpc-peering-accepter)
- [vpc-peering-requester](./modules/vpc-peering-requester)


## Target AWS Services

Terraform Modules from [this package](https://github.com/tedilabs/terraform-aws-vpc-connectivity) were written to manage the following AWS Services with Terraform.

- **AWS VPC (Virtual Private Cloud)**
  - Peering
  - PrivateLink
    - Endpoint Service
    - Gateway Endpoint
    - Interface Endpoint
- **AWS VPC Lattice**
  - Service Network
  - Service
  - Target Group
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

### Network Manager

- [reachability-analyzer](./examples/reachability-analyzer)


## Self Promotion

Like this project? Follow the repository on [GitHub](https://github.com/tedilabs/terraform-aws-vpc-connectivity). And if you're feeling especially charitable, follow **[posquit0](https://github.com/posquit0)** on GitHub.


## License

Provided under the terms of the [Apache License](LICENSE).

Copyright © 2023, [Byungjin Park](https://www.posquit0.com).
