resource "aws_launch_configuration" "ecs_launch_configuration" {
  name                 = "${var.launch_config["name"]}"
  image_id             = "${var.launch_config["image_id"]}"
  instance_type        = "${var.launch_config["instance_type"]}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.name}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = "${var.launch_config["root_volume_size"]}"
    delete_on_termination = "${var.launch_config["delete_on_termination"]}"
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${aws_security_group.private_sg.id}"]
  associate_public_ip_address = "${var.launch_config["public_ip"]}"

  user_data = <<EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
              EOF
}
