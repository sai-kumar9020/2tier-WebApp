terraform {
  backend "s3" {
    bucket = "hcltechtrainings"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
