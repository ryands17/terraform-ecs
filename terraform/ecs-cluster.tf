resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.ecs_cluster}"
}
