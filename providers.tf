terraform {
  required_version = ">= 0.12"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" 
    }
    
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
  }
}
