module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 5.0"

  topic      = "hsbc-next-best-offer-topic"
  project_id = var.gcp_project_id

    pull_subscriptions = [
    {
      name                         = "pull_next_best_offer"                                            
      ack_deadline_seconds         = 20                                                  
      # dead_letter_topic            = "projects/${var.gcp_project_id}/topics/next-best-offer-dl-topic" 
      max_delivery_attempts        = 5                                                  
      maximum_backoff              = "600s"                                               
      minimum_backoff              = "300s"                                                                   
      enable_message_ordering      = true                                               
      service_account              = var.gcp_service_account_email         
      enable_exactly_once_delivery = true                                               
    }
  ]
}