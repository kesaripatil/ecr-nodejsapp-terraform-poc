resource "aws_lb" "tf-poc" {
  name               = "tf-poc"
  subnets            = data.aws_subnets.default.ids
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

  tags = {
    Description = "Terraform_AWS-ECR_NodeJS App poc"
  }
}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.tf-poc.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-poc.arn
  }
}

resource "aws_lb_target_group" "tf-poc" {
  name        = "tf-poc-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}