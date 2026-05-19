terraform {
  backend "s3" {
    bucket         = "kubepilot-tfstate-nived"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "kube-pilot-tf-locks"
    encrypt        = true
  }
}
