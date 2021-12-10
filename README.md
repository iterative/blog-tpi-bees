An example of setting up remote cloud environment for training a machine learning model using [Iterative Terraform Provider](https://github.com/iterative/terraform-provider-iterative). 
`main.tf` contains two different tasks:
- basic scenario for running a script remotely
- training a model on a GPU device. 


To run this tutorial, make sure to have an AWS account with authentication credentials stored as environment variables.
1. Install Terraform
2. Run `terraform init` to configure workspace
3. `terraform plan` to preview infrastructure
4. `terraform apply` to create the infrastructure
5. `terraform refresh && terraform show` to monitor the state of the infrastructure
6. `terraform destroy` to destroy remote objects and sync data back to local machine
