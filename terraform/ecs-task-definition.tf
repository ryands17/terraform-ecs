data "aws_ecs_task_definition" "node_simple" {
  task_definition = "${aws_ecs_task_definition.node_simple_family.family}"
}

resource "aws_ecs_task_definition" "node_simple_family" {
  family = "node-simple-family"
  # container_definitions = "${file("service.json")}"
  container_definitions = <<DEFINITION
  [
    {
      "name": "node-simple",
      "image": "${var.ecs_image_name}",
      "essential": true,
      "portMappings": [
        {
          "hostPort": 0,
          "containerPort": 80
        }
      ],
      "memory": 128,
      "environment": [
        {
          "name": "PORT",
          "value": "80"
        }
      ]
    }
  ]
DEFINITION
}
