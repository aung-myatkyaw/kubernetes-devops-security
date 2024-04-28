resource "aws_cloudwatch_metric_alarm" "devsecops_ec2_cpu_alarm" {
  provider        = aws.mumbai
  actions_enabled = true
  alarm_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  alarm_description   = "Alarm for High CPU in DevSecOps-Jenkins"
  alarm_name          = "ec2-devsecops-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 40
  datapoints_to_alarm = 3
  evaluation_periods  = 5
  dimensions = {
    "InstanceId" = data.aws_instance.devsecops_staging.id
  }
  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  statistic   = "Average"
  period      = 300
  ok_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "devsecops_ec2_status_check_alarm" {
  provider        = aws.mumbai
  actions_enabled = true
  alarm_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  alarm_description   = "Alarm for Status Check Fail in DevSecOps-Jenkins"
  alarm_name          = "ec2-devsecops-status-check"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  datapoints_to_alarm = 1
  evaluation_periods  = 1
  dimensions = {
    "InstanceId" = data.aws_instance.devsecops_staging.id
  }
  metric_name = "StatusCheckFailed"
  namespace   = "AWS/EC2"
  period      = 60
  statistic   = "Average"
  ok_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "devsecops_ec2_memory_alarm" {
  provider        = aws.mumbai
  actions_enabled = true
  alarm_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  alarm_description   = "Alarm for High Memory Usage in DevSecOps-Jenkins"
  alarm_name          = "ec2-devsecops-high-memory"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  datapoints_to_alarm = 3
  evaluation_periods  = 5
  dimensions = {
    "InstanceId" = data.aws_instance.devsecops_staging.id
  }
  metric_name = "mem_used_percent"
  namespace   = "CWAgent"
  period      = 60
  statistic   = "Average"
  ok_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "devsecops_ec2_disk_usage_alarm" {
  provider        = aws.mumbai
  actions_enabled = true
  alarm_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  alarm_description   = "Alarm for High Disk Usage in DevSecOps-Jenkins"
  alarm_name          = "ec2-devsecops-high-disk-usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 90
  datapoints_to_alarm = 2
  evaluation_periods  = 3
  dimensions = {
    "InstanceId" = data.aws_instance.devsecops_staging.id
  }
  metric_name = "disk_used_percent"
  namespace   = "CWAgent"
  period      = 300
  statistic   = "Average"
  ok_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "devsecops_ec2_cpu_credit_alarm" {
  provider        = aws.mumbai
  actions_enabled = true
  alarm_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  alarm_description   = "Alarm for No CPU Credit in DevSecOps-Jenkins"
  alarm_name          = "ec2-devsecops-no-cpu-credit"
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  datapoints_to_alarm = 2
  evaluation_periods  = 2
  dimensions = {
    "InstanceId" = data.aws_instance.devsecops_staging.id
  }
  metric_name = "CPUCreditBalance"
  namespace   = "AWS/EC2"
  period      = 300
  statistic   = "Average"
  ok_actions = [
    data.aws_sns_topic.notification_topic.arn
  ]
  treat_missing_data = "missing"
}

# resource "aws_cloudwatch_metric_alarm" "devsecops_rds_cpu_credit_alarm" {
#   provider        = aws.mumbai
#   actions_enabled = true
#   alarm_actions = [
#     data.aws_sns_topic.notification_topic.arn
#   ]
#   alarm_description   = "Alarm for No CPU Credit in DevSecOps-Jenkins DB Instance"
#   alarm_name          = "rds-devsecops-no-cpu-credit"
#   comparison_operator = "LessThanThreshold"
#   threshold           = 1
#   datapoints_to_alarm = 2
#   evaluation_periods  = 2
#   dimensions = {
#     "DBInstanceIdentifier" = aws_db_instance.devsecops_db_instance.identifier
#   }
#   metric_name = "CPUCreditBalance"
#   namespace   = "AWS/RDS"
#   period      = 300
#   statistic   = "Average"
#   ok_actions = [
#     data.aws_sns_topic.notification_topic.arn
#   ]
#   treat_missing_data = "missing"
# }
