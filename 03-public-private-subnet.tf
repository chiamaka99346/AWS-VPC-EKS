data "aws_availability_zones" "available" {
    state = "available"
    }
    # public subnet
resource "aws_subnet" "public-subnet" {
  count = var.count-subnet 
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.main-vpc}-public-subnet-${count.index}"
  }
}


  #private subnet
resource "aws_subnet" "private-subnet" {
  count = var.count-subnet 
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.${count.index + 10}.0/24" # Use a different range for private subnets
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.main-vpc}-private-subnet-${count.index}"
  }
}