The 'aws_ce_anomaly_monitor' resource analyzes costs in AWS account and, using machine learning,
determines their limits in normal operation. In the event of an abnormal excess of expenditure limits
some service the user receives a notification.

It is possible to specify the amount of exceeding the spending limit, after which a notification will be sent.

It is possible to track expenses both for all account services and for those specified by the user.

For more information see AWS documantation:

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_monitor