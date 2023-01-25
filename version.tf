terraform {

  required_version = ">=1.3.6"

  backend "s3" {
    bucket         = "hunter-tf-backend"
    key            = "projects/scout.tfstate"
    region         = "us-west-1"
    dynamodb_table = "hunter-tf-backend-scout-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40"

    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2"

    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.3.0"
    }

  }

}
