resource "aws_security_group" "efs_security_group" {
	# checkov:skip=CKV2_AWS_5: ADD REASON
  name        = "${var.name_prefix}-efs"
  description = "${var.name_prefix} efs security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    description     = "Enable access to jenkins"
    security_groups = [aws_security_group.jenkins_controller_security_group.id]
    from_port       = 2049
    to_port         = 2049
  }

  egress {
    protocol    = "-1"
    description = "Allow outbound traffic all"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "jenkins_controller_security_group" {
	# checkov:skip=CKV2_AWS_5: ADD REASON
  name        = "${var.name_prefix}-controller"
  description = "${var.name_prefix} controller security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    self            = true
    description     = "Allow inboud self traffic"
    security_groups = var.alb_create_security_group ? [aws_security_group.alb_security_group[0].id] : var.alb_security_group_ids
    from_port       = var.jenkins_controller_port
    to_port         = var.jenkins_controller_port
  }

  ingress {
    protocol        = "tcp"
    self            = true
    description     = "Allow outbound self traffic"
    security_groups = var.alb_create_security_group ? [aws_security_group.alb_security_group[0].id] : var.alb_security_group_ids
    from_port       = var.jenkins_jnlp_port
    to_port         = var.jenkins_jnlp_port
  }
  ingress {
    protocol        = "tcp"
    description     = "Allow ingress"
    self            = true
    security_groups = var.alb_create_security_group ? [aws_security_group.alb_security_group[0].id] : var.alb_security_group_ids
    from_port       = 22
    to_port         = 22
  }

  egress {
    protocol    = "-1"
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

// ALB
resource "aws_security_group" "alb_security_group" {
  count = var.alb_create_security_group ? 1 : 0

  name        = "${var.name_prefix}-alb"
  description = "${var.name_prefix} alb security group"
  vpc_id      = var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    description = "Allow http ingress"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.allowed_cidrs 
  }

  ingress {
    protocol    = "tcp"
    description = "Allow http ingress"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.allowed_cidrs 
  }

}