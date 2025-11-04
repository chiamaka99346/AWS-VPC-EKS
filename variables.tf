variable "aws_access_key" {
  description = "The aws access key"
  type        = string
  sensitive   = true # Mark as sensitive to prevent logging
}
variable "aws_secret_key" {
  description = "The aws secret key"
  type        = string
  sensitive   = true # Mark as sensitive to prevent logging
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