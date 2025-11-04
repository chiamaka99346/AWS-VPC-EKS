variable "aws_access_key" {
  default = "AKIAQ4723WHRHLGBSFX3"
}

variable "aws_secret_key" {
  default = "gsfkfqd+pUAb8F0Ya/TjwQwwnpjkymBwEeHxU2T5"
}

variable "region" {
  default = "us-east-1"
}


variable "main-vpc" {
  default ="mainvpc"
}

 variable "vpc-cidr" {
   default = "10.0.0.0/16"
 }

  variable "count-subnet" {
    default = 2
  }