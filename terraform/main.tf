resource "aws_iam_openid_connect_provider" "github_core" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
# ecr permissions for github actions
data "aws_iam_policy_document" "ecr_permissions" {

  statement {
    sid       = "GetAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowPushPull"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = module.ecr.repository_arns
  }
}

resource "aws_iam_policy" "ecr_push_policy" {
  name        = "GitHubActions-ECR-GoldenOwl-Push-Policy"
  description = "Permissions for GitHub Actions to manage ECR images"
  policy      = data.aws_iam_policy_document.ecr_permissions.json
}

# ecs permissions for github actions
data "aws_iam_policy_document" "ecs_permissions" {
  statement {
    sid    = "ECSDeployPermissions"
    effect = "Allow"
    actions = [
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "ecs:DescribeServices"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "IAMPassRoleForECSTasks"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]

    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_deploy_policy" {
  name        = "GitHubActions-ECS-GoldenOwl-Deploy-Policy"
  description = "Permissions for GitHub Actions to deploy to ECS"
  policy      = data.aws_iam_policy_document.ecs_permissions.json
}

module "github_oidc_role_ecr" {
  source              = "./modules/github-oidc-role"
  role_name           = "github-actions-goldenowl-ci-oidc-role"
  github_repo         = var.github_repo
  oidc_provider_arn   = aws_iam_openid_connect_provider.github_core.arn
  ecr_repository_arns = module.ecr.repository_arns
  custom_policy_arns = [
    aws_iam_policy.ecr_push_policy.arn,
    aws_iam_policy.ecs_deploy_policy.arn
  ]
}

module "vpc" {
  source           = "./modules/vpc"
  vpc_subnet_az_id = var.az_ids
  vpc_cidr         = var.vpc_cidr
}

module "ecr" {
  source                = "./modules/ecr"
  scan_on_push          = var.scan_on_push
  force_delete          = var.force_delete
  image_tag_mutability  = var.image_tag_mutability
  repository_names      = var.repository_names
  allow_push_principals = var.allow_push_principals
  allow_pull_principals = var.allow_pull_principals
}

module "ecs" {
  source              = "./modules/ecs"
  cluster_name        = var.cluster_name
  app_image           = "nginxdemos/hello:latest"
  app_port            = var.app_port
  private_subnets_ids = module.vpc.private_subnet_ids
  vpc_id              = module.vpc.output_vpc_id
}

module "vpc_endpoints" {
  source              = "./modules/vpc-endpoints"
  region              = var.region
  vpc_id              = module.vpc.output_vpc_id
  vpc_cidr            = var.vpc_cidr
  private_subnet_list = module.vpc.private_subnet_ids
  route_table_list    = ["${module.vpc.private_subnet_route_table_id}"]

  depends_on = [module.vpc]
}