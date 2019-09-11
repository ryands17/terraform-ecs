resource "aws_launch_configuration" "ecs_launch_configuration" {
  name                 = "ecs-launch-configuration"
  image_id             = "ami-0e434a58221275ed4"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 30
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${aws_security_group.node_simple_private_sg.id}"]
  associate_public_ip_address = "false"

  user_data = <<EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
              EOF
}
