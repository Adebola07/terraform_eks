data "aws_availability_zones" "azs" {} 
output "azs" {
    value = data.aws_availability_zones.azs.names
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"

  name = "Eks_vpc"
  cidr = var.cidr
  private_subnets = var.private_subnet
  public_subnets = var.public_subnet 
  azs = slice(data.aws_availability_zones.azs.names,0,4)
  enable_nat_gateway = true
  single_nat_gateway = true 
  enable_dns_hostnames = true 

  tags = {
    "kubernetes.io/cluster/test-cluster" = "shared" 
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/test-cluster" = "shared" 
    "kubernetes.io/role/elb" = 1 
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/test-cluster" = "shared" 
    "kubernetes.io/role/internal-elb" = 1
  }
}