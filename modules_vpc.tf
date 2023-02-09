### MODULE VPC from C:\Dev\terraform_cours_aws


module "vpc-tp" {
  source              = "github.com/Lowess/terraform-aws-discovery"
  aws_region          = var.aws_region
  vpc_name            = var.vpc_name
}

