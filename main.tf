#creating subnetgroup for DB
resource "aws_docdb_subnet_group" "default" {
  name       = "${var.env}-docdb-subnet-groups"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.common_tags,
    { Name = "${var.env}-docdb-subnet-groups" }
  )
}

# creating security group for Rabbitmq
resource "aws_security_group" "rabbitmq" {
  name        = "${var.env}-rabbitmq-security-group"
  description = "${var.env}-rabbitmq-security-group"
  vpc_id      = var.vpc_id
  ingress {
    description = "rabbitmq"
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = var.allow_cidr
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.common_tags,
    { Name = "${var.env}-rabbitmq-security-group" }
  )
}

# creating application load balancer

resource "aws_lb" "main" {
  name               = "${var.env}-${var.subnets_name}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnet_ids

  tags = merge(
    local.common_tags,
    { Name = "${var.env}-alb-${var.subnets_name}-alb" }
  )
}