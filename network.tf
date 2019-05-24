resource "aws_vpc" "ntiernw" {
    cidr_block       = "10.0.0.0/16"
    tags{
        Name= "ntiervpc"
    }  
}
resource "aws_internet_gateway" "ig" {
    vpc_id ="${aws_vpc.ntiernw.id}"
    tags  {
     Name = "igateway"
  }
  
}

resource "aws_subnet" "web" {
    vpc_id     = "${aws_vpc.ntiernw.id}"
    cidr_block = "10.0.0.0/24"

    tags {
        Name = "web"
    }

}

resource "aws_route_table" "rt" {
   vpc_id ="${aws_vpc.ntiernw.id}"
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }
}

resource "aws_route_table_association" "as" {
  subnet_id      = "${aws_subnet.web.id}"
  route_table_id = "${aws_route_table.rt.id}"
}

resource "aws_security_group" "sg" {
  name = "sg"
  vpc_id ="${aws_vpc.ntiernw.id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
