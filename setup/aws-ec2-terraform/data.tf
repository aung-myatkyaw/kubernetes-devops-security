data "aws_ssm_parameter" "ubuntu_image" {
  provider = aws.mumbai
  name     = replace("/aws/service/canonical/ubuntu/server/22.04/stable/current/{{MACHINE_TYPE}}/hvm/ebs-gp2/ami-id", "{{MACHINE_TYPE}}", var.machine_type)
}

data "aws_ami" "devsecops_jenkins_ami_image" {
  provider = aws.mumbai
  owners   = ["self"]

  filter {
    name   = "name"
    values = [var.server_tag_value]
  }
}

resource "random_shuffle" "subnet_for_devsecops" {
  input        = data.aws_subnets.public_subnets.ids
  result_count = 1
}
