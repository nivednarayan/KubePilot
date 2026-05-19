# tells terraform where to store the state file(in s3) and make sure no two people apply at the same time
terraform {
  backend "s3" {
    bucket       = "kubepilot-tfstate-nived"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}