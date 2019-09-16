resource "aws_alb" "ecs_alb" {
  name            = "${var.load_balancer["name"]}"
  security_groups = ["${aws_security_group.public_sg.id}"]
  subnets         = ["${aws_subnet.public_subnet_1.id}", "${aws_subnet.public_subnet_2.id}"]
  enable_http2    = "true"
  idle_timeout    = "${var.load_balancer["idle_timeout"]}"
  tags = {
    Name = "${var.load_balancer["name"]}"
  }
}

output "api_url" {
  value       = "${aws_alb.ecs_alb.dns_name}"
  description = "The load balancer DNS where API's will be called from"
}

resource "aws_alb_target_group" "target_group" {
  name     = "${var.target_group["name"]}"
  port     = "${var.target_group["port"]}"
  protocol = "${var.target_group["protocol"]}"
  vpc_id   = "${aws_vpc.node_vpc.id}"
  health_check {
    healthy_threshold   = "${var.health_check["healthy_threshold"]}"
    unhealthy_threshold = "${var.health_check["unhealthy_threshold"]}"
    interval            = "${var.health_check["interval"]}"
    matcher             = "${var.health_check["matcher"]}"
    path                = "${var.health_check["path"]}"
    port                = "${var.health_check["port"]}"
    protocol            = "${var.health_check["protocol"]}"
    timeout             = "${var.health_check["timeout"]}"
  }
  stickiness = {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }
  tags = {
    Name = "${var.target_group["name"]}"
  }
  depends_on = [
    "aws_alb.ecs_alb",
  ]
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = "${aws_alb.ecs_alb.arn}"
  port              = "${var.load_balancer["port"]}"
  protocol          = "${var.load_balancer["protocol"]}"

  default_action {
    target_group_arn = "${aws_alb_target_group.target_group.arn}"
    type             = "${var.load_balancer["type"]}"
  }
}
