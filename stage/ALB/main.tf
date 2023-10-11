terraform {
  backend "s3" {
    key            = "stage/alb/terraform.tfstate" // 상태파일 저장 경로
    bucket         = "myterraform-bucket-state-hwang-t"
    region         = "ap-northeast-2"
    profile        = "terraform_user"
    dynamodb_table = "myTerraform-bucket-lock-hwang-t"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "terraform_user"
}

############## 작업순서 : ALB -> ASG ############## 

module "stage_alb" {
  source           = "github.com/ppeuming/Terraform_Project_LocalModule//aws-alb?ref=v1.1.0" # git hub tag
  name             = "stage"                                                                 # variables 설정
  vpc_id           = data.terraform_remote_state.vpc_remote_data.outputs.vpc_id
  HTTP_HTTPS_SG_id = data.terraform_remote_state.vpc_remote_data.outputs.HTTP_HTTPS_SG_id
  public_subnets   = data.terraform_remote_state.vpc_remote_data.outputs.public_subnets
}