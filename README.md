An example of setting up remote cloud environment for training a machine learning model using [Terraform Provider Iterative](https://github.com/iterative/terraform-provider-iterative).

This repository is for part 2; see the blog post at <https://dvc.org/blog/local-experiments-to-cloud-with-tpi-docker> for a full explanation. (Alternatively see part 1 of the blog at <https://dvc.org/blog/local-experiments-to-cloud-with-tpi> and the corresponding repository at <https://github.com/iterative/blog-tpi-bees>.)

The `main.tf` file defines the task (training a model on a GPU device on the cloud with a Docker image).

To run this tutorial, make sure to have a cloud account (AWS, Azure, GCP, or K8s) with [authentication credentials stored as environment variables](https://registry.terraform.io/providers/iterative/iterative/latest/docs/guides/authentication).

1. [Install Terraform](https://www.terraform.io/downloads)
2. `terraform init`: setup dependencies
3. `terraform apply`: provision cloud infrastructure & upload task
4. `terraform refresh && terraform show`: check status
5. `terraform destroy`: download results and terminate cloud infrastructure

![](https://github.com/iterative/dvc.org/raw/master/static/uploads/images/2022-05-12/header-bees.png)
