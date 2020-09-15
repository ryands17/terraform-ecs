data "aws_ecs_task_definition" "node_app" {
  task_definition = "${aws_ecs_task_definition.node_app.family}"
}

resource "aws_ecs_task_definition" "node_app" {
  family = "${var.task_definition["family"]}"
  # container_definitions = "${file("service.json")}"
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.task_definition["name"]}",
      "image": "${var.task_definition["image_name"]}",
      "essential": ${var.task_definition["essential"]},
      "portMappings": [
        {
          "hostPort": 0,
          "containerPort": 80
        }
      ],
      "memory": ${var.task_definition["memory"]},
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
