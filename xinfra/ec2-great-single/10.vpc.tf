# VPC 생성
resource "aws_vpc" "jykim-user5-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "jykim-user5-vpc"
  }
}
# 퍼블릭 서브넷 생성
resource "aws_subnet" "jykim-user5-vpc-public-subnet" {
  for_each = {
    a = { cidr = "10.0.1.0/24", az = "ap-northeast-2a" }
    b = { cidr = "10.0.2.0/24", az = "ap-northeast-2b" }
    c = { cidr = "10.0.3.0/24", az = "ap-northeast-2c" }
    d = { cidr = "10.0.4.0/24", az = "ap-northeast-2d" }
  }

  vpc_id                  = aws_vpc.jykim-user5-vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "jykim-user5-vpc-public-subnet-${each.key}"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "jykim-user5-igw" {
  vpc_id = aws_vpc.jykim-user5-vpc.id

  tags = {
    Name = "jykim-user5-igw"
  }
}

# 라우팅 테이블 생성
resource "aws_route_table" "jykim-user5-vpc-public-rt" {
  vpc_id = aws_vpc.jykim-user5-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jykim-user5-igw.id
  }

  tags = {
    Name = "jykim-user5-vpc-public-rt"
    
  }
}

resource "aws_route_table_association" "jykim-user5-vpc-public-rt" {
  for_each = {
    a = aws_subnet.jykim-user5-vpc-public-subnet["a"].id
    b = aws_subnet.jykim-user5-vpc-public-subnet["b"].id
    c = aws_subnet.jykim-user5-vpc-public-subnet["c"].id
    d = aws_subnet.jykim-user5-vpc-public-subnet["d"].id
  }
  
  subnet_id      = each.value
  route_table_id = aws_route_table.jykim-user5-vpc-public-rt.id
}