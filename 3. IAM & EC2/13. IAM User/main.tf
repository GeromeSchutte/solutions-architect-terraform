provider "aws" {
    version = "~> 2.0"
    region = "af-south-1"
    profile = "personal"
}

terraform {
    backend "s3" {
        bucket = "gerome-solutions-architect-backend"
        region = "af-south-1"
        encrypt = true
        key = "13_iam_user"
    }
}

resource "aws_iam_user" "gerome_admin" {
    name = "gerome_solutions_architect_terraform"
    force_destroy = true
}

resource "aws_iam_user_policy_attachment" "admin" {
    user = aws_iam_user.gerome_admin.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "change_password" {
    user = aws_iam_user.gerome_admin.name
    policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_access_key" "gerome_admin" {
    user    = aws_iam_user.gerome_admin.name
}

output "access_key_id" {
    value = aws_iam_access_key.gerome_admin.id
}

output "secret_access_key" {
    value = aws_iam_access_key.gerome_admin.secret
}

output "username" {
    value = aws_iam_user.gerome_admin.name
}