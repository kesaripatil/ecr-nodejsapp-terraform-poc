terraform {

  backend "s3" {
    region = "us-east-1"
    key    = "ecs-terraform-gitcicd-tfstate"
  }
}
provider "aws" {
  region     = "us-east-1"
}