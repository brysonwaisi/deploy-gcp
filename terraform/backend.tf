terraform {
  backend "gcs" {
    bucket  = "waisi-terraform"
    prefix  = "terraform/state"
    credentials = "account.json"
  }
}
