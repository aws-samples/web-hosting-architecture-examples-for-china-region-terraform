

resource "aws_security_group" "ec2_allow_elb" {
  name        = "allow_elb"
  description = "Allow traffic from elb security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "all traffic from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups  = [aws_security_group.elb_sg.id]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  ingress {
    description      = "allow ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_elb"
    Terraform = "true"
  }
}


# front end, web server 

resource "aws_launch_configuration" "web-server" {
    name_prefix = "terraform-web-"
    image_id = "${var.ec2_ami_id}"
    instance_type = "${var.ec2_instance_type}"
    user_data = "${file("nginx-user-data.sh")}"  
    key_name = "${var.key_name}" 

    security_groups =[aws_security_group.ec2_allow_elb.id]

    iam_instance_profile = aws_iam_instance_profile.test_profile.arn

    lifecycle {
        create_before_destroy = true
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = "50"
    }

}

resource "aws_autoscaling_group" "autoscaling-web-server" {
  name = "web-server"
  max_size = 4
  min_size = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.web-server.name
  vpc_zone_identifier  = module.vpc.public_subnets
  target_group_arns = [aws_lb_target_group.web-server.arn]
}


# backend, app server
resource "aws_launch_configuration" "terraform-app-server" {
    name_prefix = "terraform-app-"
    image_id = "${var.ec2_ami_id}"
    instance_type = "${var.ec2_instance_type}"
    key_name = "${var.key_name}"
    user_data = "${file("node-user-data.sh")}"   

    security_groups =[aws_security_group.ec2_allow_elb.id]

    iam_instance_profile = aws_iam_instance_profile.test_profile.arn

    lifecycle {
        create_before_destroy = true
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = "50"
    }

}


resource "aws_autoscaling_group" "autoscaling-app-server" {
  name = "app-server"
  max_size = 4
  min_size = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.terraform-app-server.name
  vpc_zone_identifier  = module.vpc.public_subnets
  target_group_arns = [aws_lb_target_group.web-backend.arn]
}



