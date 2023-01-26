provider "aws" {
  region = var.region

  default_tags {
    tags = {
      RUNTIME_ENV = "R&D"
      Maintainer  = "Hunter"
      Project     = "${var.project-name}"
      Namespace   = "${var.namespace}"
    }

  }
}
