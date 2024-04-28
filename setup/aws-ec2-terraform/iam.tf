# Instance Profile for EC2 Staging Instance
data "aws_iam_instance_profile" "staging_ec2_instance_profile" {
  name = "Role-For-Staging-Environment-EC2"
}

# Role for EC2 Spot Instance Fleet Request
data "aws_iam_role" "ec2_spot_fleet_tagging" {
  name = "aws-ec2-spot-fleet-tagging-role"
}

# Role for Maintenance windows run command
data "aws_iam_role" "maintenance_window_run_command" {
  name = "maintenance-window-run-command-role"
}

# Role for Lambda Function of processing SNS noti for spot instance changes
data "aws_iam_role" "lambda_process_sns_role" {
  name = "SNS-Publish-For-Lambda"
}
