data "aws_region" "current" {
  provider = aws.mumbai
}

data "aws_vpc" "vpc" {
  provider = aws.mumbai
  filter {
    name   = "tag:Name"
    values = ["${data.aws_region.current.name}-vpc"]
  }
}

# Get the Subnets
data "aws_subnets" "public_subnets" {
  provider = aws.mumbai
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Tier"
    values = ["Public"]
  }
}

data "aws_subnets" "private_subnets" {
  provider = aws.mumbai
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}
