
provider "google" {
  credentials = file("C:\\Users\\razda\\OneDrive\\Documents\\Keys\\Kubernetes_admin_named-signal-392608-475533c7a170.json")
  project     = var.project_id
}

variable "project_id" {
  default = "named-signal-392608"
}

variable "region" {
  default = "us-central1"
}

variable "target_bucket" {
  default = "raz-artifacts"
}

variable "function_name" {
  default = "virus_scanner"
}

# You can add more target buckets
# variable "target_bucket2" {
#     default = "${var.project_id}-packages"
# }


resource "google_storage_bucket" "function_bucket" {
  name     = "${var.project_id}-${var.function_name}"
  location = var.region
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "./src"
  output_path = "./tmp/function.zip"
}

resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"

  name   = "src-${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.function_bucket.name
}

data "google_secret_manager_secret_version" "virustotal_api" {
  secret = "VirusTotal_API_KEY" # Replace with your secret's name
}

resource "google_cloudfunctions_function" "function" {
  name        = var.function_name
  description = "Virus scanner and remover for bucket's uploaded files"
  runtime     = "python311"
  region      = var.region

  available_memory_mb = 128

  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.zip.name

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = var.target_bucket
  }

  # You can add more triggers to work on more target buckets
  #   event_trigger {
  #     event_type = "google.storage.object.finalize"
  #     resource   = "${var.project_id}-input"
  #   }

  environment_variables = {
    VirusTotal_API_KEY = data.google_secret_manager_secret_version.virustotal_api.secret_data
  }

  entry_point = "virus_scanner"
}
