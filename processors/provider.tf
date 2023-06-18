terraform {
  required_providers {
    restapi = {
      source = "Mastercard/restapi"
      version = "1.18.0"
    }
  }
}

provider "gcp-ksql" {
  # Configuration options
}

provider "aws-ksql" {
  # Configuration options
}

provider "cp-ksql" {
  # Configuration options
}

provider "gcp-connect" {
  # Configuration options
}

provider "aws-connect" {
  # Configuration options
}

provider "cp-connect" {
  # Configuration options
}