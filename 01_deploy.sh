# Delete existing terraform state
rm -rf .terraform
rm -rf terraform.tfstate
rm -rf terraform.tfstate.backup


# Initial Terraform deployment script

terraform init
terraform plan -out main.tfplan
terraform apply main.tfplan



