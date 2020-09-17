provider "aws" {
    version = "~> 3.4"
    profile = "personal"
    region = "us-west-2"
}

terraform {
    backend "s3" {
        bucket = "gerome-dev-sa-backend"
        region = "us-west-2"
        encrypt = true
        key = "15_ec2_introduction"
    }
}

resource "aws_default_vpc" "default_vpc" {
    tags = {
        Name = "gerome-dev-sa-default-vpc"
        terraform = true
    }
}

data "aws_ami" "aws_linux" {
    owners = [ "amazon" ]
    name_regex = "amazon_linux_2"
    most_recent = true
}

resource "aws_instance" "ec2" {
    ami = data.aws_ami.aws_linux.id
    instance_type = "t2.micro"

    tags = {
        Name = "gerome-dev-sa-ec2-intro"
    }
}