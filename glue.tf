resource "aws_glue_catalog_database" "data_db" {
  name = "data_db"
}

resource "aws_glue_catalog_table" "table" {
  name          = "table"
  database_name = "data_db"

  depends_on = [aws_glue_catalog_database.data_db]

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      =  "s3://${aws_s3_bucket.data-lake.id}/data/table"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "my_string"
      type = "string"
    }

    columns {
      name = "my_double"
      type = "double"
    }

    columns {
      name    = "my_date"
      type    = "date"
      comment = ""
    }

    columns {
      name    = "my_bigint"
      type    = "bigint"
      comment = ""
    }
  }
}
