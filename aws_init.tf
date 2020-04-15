#change version to desired version, leave as is for latest aws provider
provider "aws" {
  region = "us-east-2"
  #version = "~> 2.56"
  shared_credentials_file = "/root/creds"
}

