resource "aws_ecs_service" "node_simple_ecs_service" {
  name                               = "node-simple-ecs-service"
  iam_role                           = "${aws_iam_role.ecs-service-role.name}"
  cluster                            = "${aws_ecs_cluster.node_simple_cluster.id}"
  task_definition                    = "${aws_ecs_task_definition.node_simple_family.family}:${max("${aws_ecs_task_definition.node_simple_family.revision}", "${data.aws_ecs_task_definition.node_simple.revision}")}"
  desired_count                      = "${var.desired_capacity}"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  load_balancer {
    target_group_arn = "${aws_alb_target_group.node_simple_alb_tg.arn}"
    container_port   = 80
    container_name   = "${var.ecs_cluster}"
  }
}
