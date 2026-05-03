data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.2"

  name        = "${var.name}-ec2"
  description = "Allow 80 from ALB only"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [{
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    description              = "From ALB"
    source_security_group_id = var.alb_sg_id
  }]

  egress_rules = ["all-all"]
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.7"

  name = var.name

  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.sg.security_group_id]
  associate_public_ip_address = true

  user_data                   = file("${path.module}/user_data.sh")
  user_data_replace_on_change = true

  create_iam_instance_profile = true
  iam_role_policies = {
    SSM = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  metadata_options = {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device = [{
    encrypted   = true
    volume_size = 8
    volume_type = "gp3"
  }]
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = var.target_group_arn
  target_id        = module.ec2.id
  port             = 80
}
