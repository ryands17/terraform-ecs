# configuration
provider "aws" {
  profile = "default"
  version = ">= 2.1"
  region  = "${var.aws_region}"
}

variable "aws_region" {
  description = "AWS region"
}

variable "availability_zones" {
  description = "The required AWS availability zones"
}

variable "ecs_cluster" {
  description = "The ECS Cluster name"
  default     = "node-simple"
}

variable "vpc" {
  description = "The specified VPC attributes along with their tags"
}

variable "launch_config" {
  description = "The specified values to be passed to the launch configuration"
}

variable "auto_scaling" {
  description = "Auto scaling values like instance capacity"
}

variable "task_definition" {
  description = "All variables required for creating a task definition"
}

variable "ecs_service" {
  description = "The ECS service required parameters"
}

variable "load_balancer" {
  description = "The parameters related to the Application Load Balancer"
}

variable "health_check" {
  description = "Health check parameters for the Application Load Balancer"
}

variable "target_group" {
  description = "The parameters related to health checks of the load balancer"
}
