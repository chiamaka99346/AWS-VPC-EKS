resource "aws_route_table_association" "public-route-associate" {
    count =var.count-subnet
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = data.aws_route_table.selected.id
} 


resource "aws_route" "r" {
  route_table_id            = data.aws_route_table.selected.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}
# associate private ip to the nat gateway
resource "aws_route_table_association" "private-route-associate" {
    count =var.count-subnet
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = data.aws_route_table.selected.id
} 


resource "aws_route" "r1" {
    count =var.count-subnet
  route_table_id            = data.aws_route_table.selected.id
  destination_cidr_block    = "10.0.${count.index + 10}.0/24"
  gateway_id = aws_nat_gateway.nat-gateway.id
}