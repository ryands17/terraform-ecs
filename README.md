### Terraform ECS

#### A [Terraform](https://www.terraform.io) structure for setting up an ECS cluster on EC2 instances.

- A sample Node app will be deployed on AWS ECS with auto-scaling behind a load balancer.

The following variables along with their examples below are used to create this environment
Usually these go in the `terraform.tfvars` file

```tf
aws_region = "us-east-1"

availability_zones = [
  "us-east-1a",
  "us-east-1b",
]

ecs_cluster = "cluster name"

vpc = {
  "vpc_name"                    = "vpc-name"
  "cidr_block"                  = "any cidr block of your choice"
  "cidr_blocks"                 = "[an array of subnet cidr blocks]"
  "internet_gateway_name"       = "internet gateway name"
  "elastic_ip_name"             = "elastic ip name"
  "nat_gateway"                 = "nat gateway name"
  "public_subnet_names"         = "[an array of public subnet names]"
  "private_subnet_names"        = "[an array of private subnet names]"
  "public_route_table_name"     = "public rt"
  "private_route_table_name"    = "private rt"
  "public_security_group_name"  = "public sg name"
  "private_security_group_name" = "private sg name"
}

launch_config = {
  "name"                  = "launch-config-name"
  "image_id"              = "ecs optimized image id"
  "instance_type"         = "t2.micro" # scale according to your needs
  "public_ip"             = "true or false depending on public/private subnet"
  "root_volume_size"      = 30 # or any value of your size
  "delete_on_termination" = true
}
auto_scaling = {
  "name"                  = "auto scaling group name"
  "maximum_instance_size" = 3
  "minimum_instance_size" = 2
  "desired_capacity"      = 2
  "health_check_type"     = "ELB" # for load balancer health check
}

task_definition = {
  "family"     = "task definition name"
  "image_name" = "image:arn from ECR"
  "name"       = "name"
  "essential"  = true
  "memory"     = 256
}

ecs_service = {
  "name"               = "ecs service"
  "min_health_percent" = 50
  "max_health_percent" = 200
  "load_balancer_port" = 80
}

load_balancer = {
  "name"         = "alb"
  "idle_timeout" = 300
  "port"         = 80
  "protocol"     = "HTTP"
  "type"         = "forward"
}

health_check = {
  "healthy_threshold"   = "5"
  "unhealthy_threshold" = "3"
  "interval"            = "60"
  "matcher"             = "200"
  "path"                = "/url"
  "port"                = "traffic-port"
  "protocol"            = "HTTP"
  "timeout"             = "10"
}

target_group = {
  "name"     = "target group name"
  "port"     = 80
  "protocol" = "HTTP"
}
```
