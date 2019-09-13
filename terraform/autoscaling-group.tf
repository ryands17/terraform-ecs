resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                 = "${var.auto_scaling["name"]}"
  max_size             = "${var.auto_scaling["maximum_instance_size"]}"
  min_size             = "${var.auto_scaling["minimum_instance_size"]}"
  desired_capacity     = "${var.auto_scaling["desired_capacity"]}"
  vpc_zone_identifier  = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]
  launch_configuration = "${aws_launch_configuration.ecs_launch_configuration.name}"
  health_check_type    = "${var.auto_scaling["health_check_type"]}"
}
