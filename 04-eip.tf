resource "aws_eip" "nat-eip" {
  tags = {
    Name   = "${var.main-vpc}-lb-eip"
  }
}