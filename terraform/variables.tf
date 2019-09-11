# configuration
provider "aws" {
  region = "${var.aws_region}"
}

# main credentials for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

variable "aws_region" {
  description = "AWS region"
}

variable "availability_zones" {
  description = "The required AWS availability zones"
}

variable "max_instance_size" {
  description = "Maximum no. of EC2 instances"
  default     = 2
}

variable "min_instance_size" {
  description = "Minimum no. of EC2 instances"
  default     = 1
}

variable "desired_capacity" {
  description = "The desired EC2 instances"
  default     = 1
}

variable "ecs_cluster" {
  description = "The ECS Cluster name"
  default     = "node-simple"
}

variable "ecs_image_name" {
  description = "The ECR image link"
}
