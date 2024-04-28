# Launch Template for Spot instance
resource "aws_launch_template" "devsecops_template" {
  provider = aws.mumbai
  name     = "DevSecOps-Jenkins-Launch-Template"
  iam_instance_profile {
    arn = data.aws_iam_instance_profile.staging_ec2_instance_profile.arn
  }

  key_name = aws_key_pair.ec2_key.key_name

  ebs_optimized = true

  # block_device_mappings {
  #   device_name = "/dev/sda1"

  #   ebs {
  #     delete_on_termination = true
  #     volume_size           = 50
  #     volume_type           = "gp3"
  #     iops                  = 3000
  #   }
  # }

  description = "Spot Instance for devsecops jenkins"

  credit_specification {
    cpu_credits = "standard"
  }

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    private_ip_address          = "10.1.36.125"
    security_groups = [
      aws_security_group.devsecops_sg.id
    ]
  }

  update_default_version = true
  # image_id               = data.aws_ssm_parameter.ubuntu_image.value
  image_id = data.aws_ami.devsecops_jenkins_ami_image.image_id
  # user_data              = filebase64("startup-script.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = var.server_tag_value,
      "Env"  = var.environment
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "Name" = var.server_tag_value,
      "Env"  = var.environment
    }
  }
}

resource "aws_key_pair" "ec2_key" {
  provider   = aws.mumbai
  key_name   = var.staging_ec2_key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.rsa.private_key_pem
  file_permission = "0400"
  filename        = "${var.staging_ec2_key_name}.pem"
}

resource "aws_s3_object" "devsecops_staging_ssh_private_key" {
  key                    = "ec2-ssh/${var.staging_ec2_key_name}.pem"
  content                = tls_private_key.rsa.private_key_pem
  bucket                 = data.aws_s3_bucket.config_bucket.id
  server_side_encryption = "AES256"
  tags = {
    Region = data.aws_region.current.name
  }
}

resource "aws_spot_fleet_request" "devsecops_staging_fleet_request" {
  provider                            = aws.mumbai
  allocation_strategy                 = "lowestPrice"
  excess_capacity_termination_policy  = "Default"
  fleet_type                          = "maintain"
  iam_fleet_role                      = data.aws_iam_role.ec2_spot_fleet_tagging.arn
  instance_interruption_behaviour     = "terminate"
  instance_pools_to_use_count         = 1
  on_demand_allocation_strategy       = "lowestPrice"
  on_demand_target_capacity           = 0
  replace_unhealthy_instances         = true
  target_capacity                     = 1
  terminate_instances_with_expiration = true
  wait_for_fulfillment                = true

  # depends_on = [
  #   aws_eip.devsecops_ip
  # ]

  spot_maintenance_strategies {
    capacity_rebalance {
      replacement_strategy = "launch"
    }
  }

  launch_template_config {
    launch_template_specification {
      id      = aws_launch_template.devsecops_template.id
      version = "$Default"
    }

    dynamic "overrides" {
      for_each = var.staging_spot_instance_types
      content {
        instance_type = overrides.value
        subnet_id     = data.aws_subnets.public_subnets.ids[0]
      }
    }

    dynamic "overrides" {
      for_each = var.staging_spot_instance_types
      content {
        instance_type = overrides.value
        subnet_id     = data.aws_subnets.public_subnets.ids[1]
      }
    }

    dynamic "overrides" {
      for_each = var.staging_spot_instance_types
      content {
        instance_type = overrides.value
        subnet_id     = data.aws_subnets.public_subnets.ids[2]
      }
    }
  }
}

data "aws_instance" "devsecops_staging" {
  provider = aws.mumbai
  filter {
    name   = "instance-lifecycle"
    values = ["spot"]
  }

  filter {
    name   = "tag:Name"
    values = [var.server_tag_value]
  }

  filter {
    name   = "tag:Env"
    values = [var.environment]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  # filter {
  #   name   = "ip-address"
  #   values = [aws_eip.devsecops_ip.public_ip]
  # }

  depends_on = [aws_spot_fleet_request.devsecops_staging_fleet_request]
}

# resource "aws_instance" "devsecops_staging" {
#   provider = aws.mumbai
#   # disable_api_termination = true

#   depends_on = [
#     aws_db_instance.devsecops_db_instance
#   ]

#   associate_public_ip_address = false
#   disable_api_stop            = false
#   disable_api_termination     = false
#   instance_type               = var.staging_spot_instance_types[0]
#   subnet_id                   = random_shuffle.subnet_for_devsecops.result[0]
#   tags = {
#     "Name" = "devsecops"
#   }

#   credit_specification {
#     cpu_credits = "standard"
#   }

#   launch_template {
#     id      = aws_launch_template.devsecops_template.id
#     version = "$Default"
#   }

#   lifecycle {
#     ignore_changes = [ami, user_data, launch_template, associate_public_ip_address]
#   }
# }

# Elastic IP for DevSecOps-Jenkins Staging
resource "aws_eip" "devsecops_ip" {
  provider = aws.mumbai
  instance = data.aws_instance.devsecops_staging.id
  tags = {
    "Name" = var.server_tag_value,
    "Env"  = var.environment
  }
  domain = "vpc"
}

# Security Group for DevSecOps-Jenkins Staging
resource "aws_security_group" "devsecops_sg" {
  provider = aws.mumbai
  name     = "devsecops-staging"
  vpc_id   = data.aws_vpc.vpc.id
  tags = {
    "Name" = var.server_tag_value
  }
  description = "SG for DevSecOps-Jenkins Staging Server"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 443
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 443
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 80
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 80
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 8080
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 8080
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 9000
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 9000
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 15021
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 15021
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 31400
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 31400
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 15443
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 15443
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = var.istio_ingress_gateway_nodeport
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = var.istio_ingress_gateway_nodeport
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_ssm_association" "devsecops_staging_cloud_watch_update" {
  provider                    = aws.mumbai
  association_name            = "Cloud_Watch_Agent_For_DevSecOps_Jenkins_Staging"
  apply_only_at_cron_interval = true
  name                        = "AWS-ConfigureAWSPackage"
  parameters = {
    "action"           = "Install"
    "installationType" = "Uninstall and reinstall"
    "name"             = "AmazonCloudWatchAgent"
  }
  schedule_expression = "cron(0 23 ? * SUN *)"

  targets {
    key = "tag:Name"
    values = [
      var.server_tag_value
    ]
  }
}

resource "aws_ssm_maintenance_window" "devsecops_maintenace_window" {
  provider                   = aws.mumbai
  allow_unassociated_targets = false
  cutoff                     = 0
  description                = "Patching Windows for DevSecOps-Jenkins Staging Server"
  duration                   = 1
  enabled                    = true
  name                       = var.server_tag_value
  schedule                   = "cron(0 22 ? * SUN *)"
  schedule_timezone          = "Asia/Yangon"
}

resource "aws_ssm_maintenance_window_target" "devsecops_target" {
  provider      = aws.mumbai
  window_id     = aws_ssm_maintenance_window.devsecops_maintenace_window.id
  description   = "Target for DevSecOps-Jenkins Staging EC2 Instance"
  name          = var.server_tag_value
  resource_type = "INSTANCE"

  depends_on = [
    aws_spot_fleet_request.devsecops_staging_fleet_request
  ]

  targets {
    key = "tag:Name"
    values = [
      var.server_tag_value,
      var.environment
    ]
  }
}

resource "aws_ssm_maintenance_window_task" "devsecops_window_task" {
  provider         = aws.mumbai
  cutoff_behavior  = "CANCEL_TASK"
  description      = "Patching Run Command for Ubuntu"
  max_concurrency  = "100%"
  max_errors       = "50%"
  name             = "DevSecOps-Jenkins-Staging-Server-Ubuntu-Patching"
  priority         = 1
  service_role_arn = data.aws_iam_role.maintenance_window_run_command.arn
  task_arn         = "AWS-RunPatchBaseline"
  task_type        = "RUN_COMMAND"
  window_id        = aws_ssm_maintenance_window.devsecops_maintenace_window.id

  targets {
    key = "WindowTargetIds"
    values = [
      aws_ssm_maintenance_window_target.devsecops_target.id
    ]
  }

  task_invocation_parameters {

    run_command_parameters {
      document_version = "$LATEST"
      timeout_seconds  = 600

      cloudwatch_config {
        cloudwatch_log_group_name = aws_cloudwatch_log_group.devsecops_patching_task_log_group.name
        cloudwatch_output_enabled = true
      }

      parameter {
        name = "Operation"
        values = [
          "Install",
        ]
      }
      parameter {
        name = "RebootOption"
        values = [
          "RebootIfNeeded",
        ]
      }
    }
  }
}

// Cloud Watch Log Group
resource "aws_cloudwatch_log_group" "devsecops_patching_task_log_group" {
  provider          = aws.mumbai
  name              = "/aws/ssm/devsecops-staging-ubuntu-server-patching"
  retention_in_days = 30
}
