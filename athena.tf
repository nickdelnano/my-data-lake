resource "aws_athena_data_catalog" "data-lake" {
  name        = "data-lake"
  description = "Glue based Data Catalog"
  type        = "GLUE"

  parameters = {
    "catalog-id" = local.account_id
  }
}

data "aws_caller_identity" "current" {}
locals {
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_athena_workgroup" "main" {
  name = "main"


  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true
    bytes_scanned_cutoff_per_query = 10737418240 // 10GB

    engine_version {
      selected_engine_version = "Athena engine version 3" // Use V3 engine to get new features
    }

    result_configuration {
      output_location = "s3://${aws_s3_bucket.data-lake.bucket}/athena_output/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}
