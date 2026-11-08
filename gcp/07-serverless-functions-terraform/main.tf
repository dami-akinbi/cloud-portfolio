# 1. Cloud Storage Bucket for Source Code
resource "google_storage_bucket" "function_bucket" {
  name                        = "bkt-func-portfolio-${var.environment}-${var.project_id}"
  project                     = var.project_id
  location                    = var.region
  uniform_bucket_level_access = true
}

# 2. Dynamic Zip Archive Generation
data "archive_file" "source" {
  type        = "zip"
  output_path = "${path.module}/function-source.zip"
  source {
    content  = "exports.helloWorld = (req, res) => {res.status(200).send('Hello from GCP Serverless!');};"
    filename = "index.js"
  }
}

# 3. Upload Zip to Bucket
resource "google_storage_bucket_object" "archive" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.source.output_path
}

# 4. Cloud Function
resource "google_cloudfunctions_function" "function" {
  name                  = "func-portfolio-${var.environment}"
  project               = var.project_id
  description           = "Serverless function for multicloud portfolio"
  runtime               = "nodejs20"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "helloWorld"
  region                = var.region
}

# 5. Public Invoker Access (For easy testing in the browser)
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}

output "function_url" {
  value       = google_cloudfunctions_function.function.https_trigger_url
  description = "The live URL to invoke the serverless function"
}
