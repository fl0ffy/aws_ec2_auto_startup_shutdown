data "archive_file" "default" {
  type        = "zip"
  source_dir  = "${path.module}/files"
  output_path = "${path.module}/myzip/python.zip"
}