terraform {
    required_providers {
        aws = {
            version = ">=5.60.0"
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    region = "eu-west-1"
}