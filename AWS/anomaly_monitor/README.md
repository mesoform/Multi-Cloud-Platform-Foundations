You can use Cost monitor to monitor costs in AWS. Cost monitor
uses machine learning to track your spending in the AWS environment and automatically notifies you when it exceeds a user-defined threshold.

To create a Cost monitor in the AWS console, you need to:

1. Go to AWS `Cost mamagement/Cost anomaly detection`
2. Select the `Cost monitors` tab
3. Select `Create monitor`

You can choose from several options for Cost monitors:

- AWS Services - Recommended  
This monitor evaluates each of the services you use individually, allowing smaller anomalies to be detected. Anomaly thresholds are automatically adjusted based on your historical service spend patterns.

- Linked account  
This monitor evaluates total spend for an individual Linked Account. This monitor can be helpful if your organization defines teams (or products, services, environments) by linked account.

- Cost Category  
This monitor evaluates total spend for an individual cost category value. This monitor can be helpful if your organization defines teams (or products, services, environments) by using cost categories.

- Cost Allocation Tag  
This monitor evaluates total spend for an individual tag key-value pair. This monitor can be helpful if your organization defines teams (or products, services, environments) by using cost allocation tags.

After that, you will be prompted to set up an alert subscription

An alert subscription notifies you when a cost monitor detects an anomaly. Depending on the alert frequency, you can notify designated individuals by email or Amazon SNS. For example, you can create a subscription for the Finance team in your organization.

You can create up to two subscriptions when you are creating a monitor. Each subscription specifies an alert threshold, frequency and delivery options. To get started, choose Create a new subscription.

You can make changes to existing subscriptions on the Alert subscriptions tab of the Overview page.

You can also create a Cost monitor using the AWS CLI:

https://docs.aws.amazon.com/cli/latest/reference/ce/create-anomaly-monitor.html

Example:

1. Create and save the document to a JSON file named cost_monitor.json:
```json
{
  "MonitorName": "cc-cost-anomaly-detection-monitor",
  "MonitorType": "DIMENSIONAL",
  "MonitorDimension": "SERVICE"
}
```
2. Run create-anomaly-monitor command:

`aws ce create-anomaly-monitor --region us-east-1 --anomaly-monitor file://cost_monitor.json`

3. The command output should return the Amazon Resource Name (ARN) of the new monitor:
```json
{
    "MonitorArn": "arn:aws:ce::123456789012:anomalymonitor/abcdabcd-1234-abcd-1234-abcd1234abcd"
}
```
4. Save the following configuration document to a JSON file named cost_monitor_subscription.json
```json
{
    "MonitorArnList": [
        "arn:aws:ce::123456789012:anomalymonitor/abcdabcd-1234-abcd-1234-abcd1234abcd"
    ],
    "SubscriptionName": "cc-cost-monitor-subscription",
    "Frequency": "DAILY",
    "Subscribers": [
        {
            "Status": "CONFIRMED",
            "Type": "EMAIL",
            "Address": "alert@cloudconformity.com"
        }
    ],
    "Threshold": 100.0,
    "AccountId": "123456789012"
}
```
5. Run create-anomaly-subscription command:

`aws ce create-anomaly-subscription --region us-east-1 --anomaly-subscription file://cost_monitor_subscription.json`