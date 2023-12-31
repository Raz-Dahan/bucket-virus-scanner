﻿# bucket-virus-scanner

This project is a serverless process using GCP Cloud Functions that scan files uploaded to a GCP bucket for viruses using VirusTotal. The scanning process will be triggered when a new file is uploaded to the specified GCP bucket and the dangerous files are deleted.

## Prerequisites

- [GCP Account and Project](https://console.cloud.google.com/project)
- [GCP Cloud Storage Bucket](https://console.cloud.google.com/storage/browser)
- [GCP Cloud Functions API enabled](https://console.cloud.google.com/functions)
- GCP Service Account with "Service Account User", "Secrets Manager Admin", "Storage Admin" and "Cloud Functions Admin" IAM roles 
- [VirusTotal API Key](https://www.virustotal.com/gui/join-us) stored in [GCP Secret Manager](https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets)
- Optional - [Terraform installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Implementation

1. Implement a GCP Cloud Function that triggers on a new file upload to the specified GCP bucket (google.cloud.storage.object.v1.finalized)

2. Fetch the VirusTotal API Key securely from GCP Secret Manager within the Cloud Function as an Environment variable

Or

- Clone this git repository

   ```bash
   git clone https://github.com/Raz-Dahan/bucket-virus-scanner.git
   cd ./bucket-virus-scanner
   ```
- Change relevant variables in `main.tf`

- Deploy on GCP using Terraform

   ```bash
   cd ./terraform
   terraform init
   terraform plan
   ```

    And, if suitable for your requirements, proceed to

    ```bash
    terraform apply
    ```

## Resources
- [Python Client library for Google Cloud Storage](https://cloud.google.com/python/docs/reference/storage/latest)
- [Python client library for the VirusTotal API](https://virustotal.github.io/vt-py/index.html)
- [Google Cloud Platform Provider for Terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Deploy Cloud Functions on GCP with Terraform - Medium article](https://towardsdatascience.com/deploy-cloud-functions-on-gcp-with-terraform-111a1c4a9a88)
