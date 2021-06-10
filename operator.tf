
variable "region" { default = "us-east-1" }
variable "path" { default = "../vault-admin-workspace/terraform.tfstate" }
variable "ttl" { default = "1" }
variable "backend" { default = "dynamic-aws-creds-vault-admin-path"}
variable "role" {default = "dynamic-aws-creds-vault-admin-role" }

/*
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

data "terraform_remote_state" "admin" {
  backend = "local"

  config = {
    path = var.path
  }
}
*/ 

data "vault_aws_access_credentials" "creds" {
  backend = var.backend
  role    = var.role
  depends_on = [
    vault_aws_secret_backend_role.admin
  ]
}


provider "aws" {
  region     = var.region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

