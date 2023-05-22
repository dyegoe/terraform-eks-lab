provider "aws" {
  region = "eu-north-1"
}

resource "aws_ssm_parameter" "secrets" {
  name  = "testingAtlantis"
  type  = "String"
  value = "This is a secret"

  tags = {
    Name = "testingAtlantis"
  }
}
