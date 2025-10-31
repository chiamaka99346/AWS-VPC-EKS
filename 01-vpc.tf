resource "aws_vpc" "main-vpc" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"

  tags = {
    Name = var.main-vpc
  }
}