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

resource "aws_security_group" "ssh_group" {
    name = "allow_ssh"
    description = "Allow us to SSH into EC2 instances"
    vpc_id = aws_default_vpc.default_vpc.id

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        from_port = 22
        to_port = 22
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_ssh"
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
    security_groups = [ aws_security_group.ssh_group.name ]

    tags = {
        Name = "gerome-dev-sa-ec2-intro"
    }
}