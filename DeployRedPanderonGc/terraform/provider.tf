terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
  }
  required_version = ">= 1.3.0"
}

provider "google" {
  project     = "ai92-c"
  region      = var.region
  credentials = file("C:/Users/koloxo/AppData/Roaming/gcloud/application_default_credentials.json")
}
