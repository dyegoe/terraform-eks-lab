# terraform-eks-lab

Terraform EKS Lab is a project to create a lab environment for learning EKS.

## Usage

### Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 1.4.6
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) >= 2.2.44
- [Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) >= 1.26 (or version that matches the EKS version)
- An AWS account with permissions to create the resources

### Setup

To deploy the main resources, run the following commands:

```bash
cd eks-cluster/
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

## Improvements

- Add security groups across the resources

## Author

Dyego Alexandre Eugenio <its.me@dyego.com.br>

## License

Mozilla Public License (MPL) 1.1

## Project status

This project is currently in development. Users should be cautious when using this project for anything other than testing and development.
