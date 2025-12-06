module "aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.8.4"

  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::892706795826:user/Terrafrom-User"
      username = "Terrafrom-User"
      groups   = ["system:masters"]
    }
  ]
}