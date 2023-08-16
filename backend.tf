terraform {
  backend "s3" {
    bucket         = "terraformstate8479374"
    key            = "estudosterraform01/terraform.tfstate"
    region         = "us-east-1"  # Substitua pela região desejada
    encrypt        = true
    
  }
}