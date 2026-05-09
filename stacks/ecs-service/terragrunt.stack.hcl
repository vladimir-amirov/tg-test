locals {
  catalog_ref = "main"
}

# TODO: compose units — lb-service-attachment (x2) + ecs-service
# unit "lb_int" { ... }
# unit "lb_pub" { ... }
# unit "ecs_service" { dependencies = [unit.lb_int, unit.lb_pub] ... }
