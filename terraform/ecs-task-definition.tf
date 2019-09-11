data "aws_ecs_task_definition" "node_simple" {
  task_definition = "${aws_ecs_task_definition.node_simple_family.family}"
}

resource "aws_ecs_task_definition" "node_simple_family" {
  family                = "node-simple-family"
  container_definitions = "${file("service.json")}"
}
