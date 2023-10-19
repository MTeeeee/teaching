terraform {
  required_version = ">= 1.0" # Wir wollen mindestens terraform version 1.0 verwenden

  required_providers {
    aws = {  # Der AWS Provider ermöglicht es AWS Resourcen zu erstellen
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region # Diese Terraform variable definieren wir im nächsten Schritt
  profile = var.aws_profile # BITTE DEIN AWS PROFILE EINTRAGEN
}