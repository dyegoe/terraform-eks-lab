# terraform-eks-lab

Terraform EKS Lab is a project to create a lab environment for learning EKS.

## Usage

### Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 1.4.6
- [Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) >= 1.26 (or version that matches the EKS version)

### Setup

```bash
cd terraform/
terraform init
terraform apply
```

### Connect to the cluster

You can use the terraform output to fill the command, for example:

```bash
aws --region $(terraform output -raw region) eks update-kubeconfig --name $(terraform output -raw cluster_name)
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
