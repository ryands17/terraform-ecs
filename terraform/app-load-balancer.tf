resource "aws_alb" "node_simple_alb" {
  name            = "node-simple-alb"
  security_groups = ["${aws_security_group.node_simple_public_sg.id}"]
  subnets         = ["${aws_subnet.node_simple_public.id}", "${aws_subnet.node_simple_public2.id}"]
  tags = {
    Name = "node-simple-alb"
  }
}

resource "aws_alb_target_group" "node_simple_alb_tg" {
  name     = "node-simple-alb-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.node_simple_vpc.id}"
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "4"
    interval            = "60"
    matcher             = "200"
    path                = "/health-check"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "10"
  }
  tags = {
    Name = "node-simple-alb-tg"
  }
  depends_on = [
    "aws_alb.node_simple_alb",
  ]
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = "${aws_alb.node_simple_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.node_simple_alb_tg.arn}"
    type             = "forward"
  }
}
