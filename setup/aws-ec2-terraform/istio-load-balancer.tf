resource "aws_lb" "devsecops_jenkins_nlb" {
  provider                         = aws.mumbai
  dns_record_client_routing_policy = "any_availability_zone"
  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false
  internal                         = false
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  name                             = var.server_tag_value
  security_groups = [
    aws_security_group.devsecops_sg.id
  ]

  subnet_mapping {
    allocation_id = aws_eip.nlb_ip.id
    subnet_id     = data.aws_instance.devsecops_staging.subnet_id
  }
}

resource "aws_eip" "nlb_ip" {
  provider             = aws.mumbai
  domain               = "vpc"
  network_border_group = "ap-south-1"
  public_ipv4_pool     = "amazon"
}

resource "aws_lb_listener" "devsecops_jenkins_nlb_listener" {
  provider          = aws.mumbai
  load_balancer_arn = aws_lb.devsecops_jenkins_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.devsecops_jenkins_nlb_target.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "devsecops_jenkins_nlb_target" {
  provider                          = aws.mumbai
  connection_termination            = false
  deregistration_delay              = "300"
  ip_address_type                   = "ipv4"
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  name                              = var.server_tag_value
  port                              = var.istio_ingress_gateway_nodeport
  preserve_client_ip                = "true"
  protocol                          = "TCP"
  proxy_protocol_v2                 = false
  target_type                       = "instance"
  vpc_id                            = data.aws_vpc.vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    port                = var.istio_ingress_gateway_nodeport
    protocol            = "TCP"
    timeout             = 10
    unhealthy_threshold = 2
  }

  stickiness {
    enabled = false
    type    = "source_ip"
  }

  target_health_state {
    enable_unhealthy_connection_termination = true
  }
}

resource "aws_lb_target_group_attachment" "nlb_target_group_instance" {
  provider         = aws.mumbai
  target_group_arn = aws_lb_target_group.devsecops_jenkins_nlb_target.arn
  target_id        = data.aws_instance.devsecops_staging.id
  port             = var.istio_ingress_gateway_nodeport
}
