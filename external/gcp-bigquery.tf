module "bigquery" {
  source                     = "terraform-google-modules/bigquery/google"
  dataset_id                 = "hsbc_customers"
  dataset_name               = "hsbc-customers-analytics"
  description                = "Bq dataset to anaylse customer activity from field operations."
  project_id                 = var.gcp_project_id
  location                   = "US"
  delete_contents_on_destroy = true
  tables = [
    # {
    #   table_id           = "hsbc_customer_activity",
    #   schema             = file("${path.module}/hsbc_customer_activity_schema.json"),
    #   time_partitioning  = null,
    #   range_partitioning = null,
    #   expiration_time    = 2524604400000, # 2050/01/01
    #   clustering         = [],
    #   labels = {
    #     env      = "analytics"
    #     billable = "true"
    #     purpose    = "strategic"
    #   },
    # },
      {
      table_id           = "aws_customer_propensity_score",
      schema             = file("${path.module}/hsbc_customer_activity_schema.json"),
      time_partitioning  = null,
      range_partitioning = null,
      expiration_time    = 2524604400000, # 2050/01/01
      clustering         = [],
      labels = {
        env      = "analytics"
        billable = "true"
        purpose    = "strategic"
      },
    }
    # {
    #   table_id           = "cp_enriched_customer_behaviour",
    #   schema             = file("${path.module}/hsbc_customer_activity_schema.json"),
    #   time_partitioning  = null,
    #   range_partitioning = null,
    #   expiration_time    = 2524604400000, # 2050/01/01
    #   clustering         = [],
    #   labels = {
    #     env      = "analytics"
    #     billable = "true"
    #     purpose    = "strategic"
    #   },
    # }
  ]
  dataset_labels = {
    env      = "analytics"
    billable = "true"
    purpose    = "strategic"
  }
}