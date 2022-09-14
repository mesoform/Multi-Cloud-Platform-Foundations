resource "aws_ce_anomaly_monitor" "self" {
  name              = "AWSServiceMonitor"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "aws_ce_anomaly_subscription" "self" {
  name      = "DAILYSUBSCRIPTION"
  threshold = var.threshold
  frequency = "DAILY"

  monitor_arn_list = [
    aws_ce_anomaly_monitor.self.arn,
  ]

  subscriber {
    type    = "EMAIL"
    address = var.subscription_email
  }
}