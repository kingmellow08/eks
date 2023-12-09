
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = tomap({
    "Name"                          = "eks-vpc"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  })
}

resource "aws_subnet" "priv-eu-north-1a" {
  #count = 2

  #availability_zone = data.aws_availability_zones.available.names[count.index]
  availability_zone = "eu-north-1a"
  #cidr_block        = "10.0.${count.index}.0/24"
  cidr_block        = "10.0.10.0/24"
  vpc_id            = aws_vpc.vpc.id

  tags = tomap({
    "Name"                          = "priv-eu-north-1a"
    "kubernetes.io/role/elb"        = "1"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  })
}

resource "aws_subnet" "priv-eu-north-1b" {
  #count = 2

  #availability_zone = data.aws_availability_zones.available.names[count.index]
  availability_zone = "eu-north-1b"
  #cidr_block        = "10.0.${count.index}.0/24"
  cidr_block        = "10.0.20.0/24"
  vpc_id            = aws_vpc.vpc.id

  tags = tomap({
    "Name"                          = "priv-eu-north-1b"
    "kubernetes.io/role/elb"        = "1"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  })
}

resource "aws_subnet" "priv-eu-north-1c" {
  #count = 2

  #availability_zone = data.aws_availability_zones.available.names[count.index]
  availability_zone = "eu-north-1c"
  #cidr_block        = "10.0.${count.index}.0/24"
  cidr_block        = "10.0.30.0/24"
  vpc_id            = aws_vpc.vpc.id

  tags = tomap({
    "Name"                          = "priv-eu-north-1c"
    "kubernetes.io/role/elb"        = "1"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  })
}

resource "aws_subnet" "pub-eu-north-1a" {

  availability_zone = "eu-north-1a"
  cidr_block        = "10.0.40.0/24"
  vpc_id            = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = tomap({
    "Name"                          = "pub-eu-north-1a"
    "kubernetes.io/role/elb"        = "1"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  })
}

resource "aws_subnet" "pub-eu-north-1b" {

  availability_zone = "eu-north-1b"
  cidr_block        = "10.0.50.0/24"
  vpc_id            = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = tomap({
    "Name"                          = "pub-eu-north-1b"
    "kubernetes.io/role/elb"        = "1"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  })
}

resource "aws_subnet" "pub-eu-north-1c" {

  availability_zone = "eu-north-1c"
  cidr_block        = "10.0.60.0/24"
  vpc_id            = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = tomap({
    "Name"                          = "pub-eu-north-1c"
    "kubernetes.io/role/elb"        = "1"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}


resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub-eu-north-1a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "priv" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "priv-eu-north-1a" {

  subnet_id      = aws_subnet.priv-eu-north-1a.id
  route_table_id = aws_route_table.priv.id
}

resource "aws_route_table_association" "priv-eu-north-1b" {

  subnet_id      = aws_subnet.priv-eu-north-1b.id
  route_table_id = aws_route_table.priv.id
}

resource "aws_route_table_association" "priv-eu-north-1c" {

  subnet_id      = aws_subnet.priv-eu-north-1c.id
  route_table_id = aws_route_table.priv.id
}

resource "aws_route_table_association" "pub-eu-north-1a" {

  subnet_id      = aws_subnet.pub-eu-north-1a.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub-eu-north-1b" {

  subnet_id      = aws_subnet.pub-eu-north-1b.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub-eu-north-1c" {

  subnet_id      = aws_subnet.pub-eu-north-1c.id
  route_table_id = aws_route_table.pub.id
}
