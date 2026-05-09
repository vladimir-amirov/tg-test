# Shape matches terraform-aws-modules/alb output so the ecs-service dependency block works:
# dependency.lb_int.outputs.target_groups["service"].arn
output "target_groups" {
  description = "Target group map — key 'service' exposes the ARN consumed by the ecs-service unit"
  value = {
    service = {
      arn = aws_lb_target_group.this.arn
    }
  }
}
