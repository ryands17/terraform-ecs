resource "aws_ecs_cluster" "node_simple_cluster" {
  name = "${var.ecs_cluster}"
}
