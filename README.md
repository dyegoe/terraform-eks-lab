# terraform-eks-lab

## Table of Contents

- [terraform-eks-lab](#terraform-eks-lab)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Considerations](#considerations)
  - [Usage](#usage)
    - [Requirements](#requirements)
    - [Setup](#setup)
    - [Connect to the cluster](#connect-to-the-cluster)
  - [Contributing](#contributing)
  - [Development](#development)
    - [Requirements for development](#requirements-for-development)
    - [Setup for development](#setup-for-development)
  - [Author](#author)
  - [License](#license)
  - [Project status](#project-status)

## Description

This project is used to deploy an EKS cluster and some Kubernetes resources to it. The EKS cluster is deployed using Terraform and the Kubernetes resources are deployed using Terraform and Helm provider.

## Considerations

- VPC with public and private subnets
- EKS cluster with a managed node group
- SSL Certificate to provide HTTPS access to the resources
- RBAC roles
- It is a temporary lab, so there is no restriction to access the resources. In a production environment, the access should be restricted to the necessary users and networks
- This Terraform uses S3 remote state, so you need to provide the information in the `main.tf` file of each directory
- Improvements:
  - Add security groups across the resources to mitigate the risk of exposing the resources to the internet
  - Remove public access from the EKS cluster

## Usage

### Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 1.4.6
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) >= 2.2.44
- [Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) >= 1.26 (or version that matches the EKS version)
- An AWS account with permissions to create the resources and proper credentials configured using one of the [AWS CLI methods](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- A S3 bucket to store the Terraform state. You should provide the information in the `main.tf` file of each directory.
- A zone in Route53 to create the DNS records. You need to provide the zone name in the `terraform.tfvars` file
- GitHub account properly configured to clone the repository (SSH key or username/password)
- GitHub personal token with the permissions as described [here](https://www.runatlantis.io/docs/access-credentials.html#github-user)

### Setup

Clone the repository:

```bash
git clone git@github.com:dyegoe/terraform-eks-lab.git
cd terraform-eks-lab/
```

To deploy the main resources, run the following commands:

```bash
cd eks-cluster/
```

You may edit the `main.tf` file to change the S3 remote backend information.

```terraform
terraform {
  backend "s3" {
    bucket = "dyego-terraform"
    key    = "terraform-eks-lab/eks-cluster/terraform.tfstate"
    region = "us-east-1"
  }

  ...
}
```

You may edit the `terraform.tfvars` file to change the default values.

```bash
terraform init
terraform apply
```

To deploy the Kubernetes resources, run the following commands:

```bash
cd ../kubernetes/
```

You may edit the `main.tf` file to change the S3 remote backend information.

```terraform
terraform {
  backend "s3" {
    bucket = "dyego-terraform"
    key    = "terraform-eks-lab/eks-cluster/terraform.tfstate"
    region = "us-east-1"
  }

  ...
}
```

You may edit the `terraform.tfvars` file to change the default values, but you must provide some secrets, like the GitHub token.

```bash
vi secrets.auto.tfvars
```

and add this content:

```terraform
github = {
  user   = "<username>"
  token  = "<github personal token>"
  secret = "<any 32 character string>"
}

atlantis_basic_auth = {
  username = "<username>"
  password = "<password>"
}
```

```bash
terraform init
terraform apply
```

### Connect to the cluster

You can use the terraform output to fill the command, for example:

```bash
cd ../eks-cluster/
aws --region $(terraform output -raw aws_region) eks update-kubeconfig --name $(terraform output -raw cluster_name)
```

or you can manually provide the values, for example:

```bash
aws --region us-east-1 eks update-kubeconfig --name terraform-eks-lab
```

Time to test the connection:

```bash
kubectl get nodes
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Development

### Requirements for development

- [pre-commit](https://pre-commit.com/#install) >= 3.3.2
- [Terraform](https://www.terraform.io/downloads.html) >= 1.4.6

### Setup for development

```bash
pre-commit install
go install github.com/terraform-docs/terraform-docs@v0.16.0
```

## Author

Dyego Alexandre Eugenio <its.me@dyego.com.br>

## License

Mozilla Public License (MPL) 1.1

## Project status

This project is currently in development. Users should be cautious when using this project for anything other than testing and development.
