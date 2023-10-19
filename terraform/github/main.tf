terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# create repository
provider "github" {
    token = "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"
}

# Add a user to the organization
resource "github_repository" "terraform_test" {
  name        = "example"
  description = "My awesome codebase"

  visibility = "private"

}