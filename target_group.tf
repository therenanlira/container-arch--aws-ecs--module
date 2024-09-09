locals {
  target_group_resource_name = "ecs-tg"
}

resource "aws_lb_target_group" "ecs_target_group" {
  name = "${var.cluster_name}--${local.target_group_resource_name}"

  vpc_id      = var.vpc_id
  port        = var.service_port
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    healthy_threshold   = lookup(var.service_healthcheck, "healthy_threshold", "3")
    unhealthy_threshold = lookup(var.service_healthcheck, "unhealthy_threshold", "10")
    timeout             = lookup(var.service_healthcheck, "timeout", "10")
    interval            = lookup(var.service_healthcheck, "interval", "60")
    matcher             = lookup(var.service_healthcheck, "matcher", "200")
    path                = lookup(var.service_healthcheck, "path", "/")
    port                = lookup(var.service_healthcheck, "port", var.service_port)
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name     = "${var.cluster_name}--${local.target_group_resource_name}"
    Resource = "ecs-target-group"
  }
}