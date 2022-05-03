An example of setting up remote cloud environment for training a machine learning model using [Terraform Provider Iterative](https://github.com/iterative/terraform-provider-iterative).

`main.tf` contains two different tasks:

1. basic scenario for running a script remotely, and
2. training a model on a GPU device

To run this tutorial, make sure to have a cloud account (AWS, Azure, GCP, or K8s) with [authentication credentials stored as environment variables](https://registry.terraform.io/providers/iterative/iterative/latest/docs/guides/authentication).

1. [Install Terraform](https://www.terraform.io/downloads)
2. `terraform init`: setup dependencies
3. `terraform apply`: provision cloud infrastructure & upload task
4. `terraform refresh && terraform show`: check status
5. `terraform destroy`: download results and terminate cloud infrastructure
