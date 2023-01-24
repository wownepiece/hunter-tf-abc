provider "aws" {
  region = var.region

  default_tags {
    tags = {
      RUN_TIME_ENV = "RD"
      MAINTAINER   = "HUNTER"
    }

  }
}
