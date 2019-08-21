provider "aws" {
	region					= "${var.aws_region}"
	shared_credentials_file	= "${var.aws_account_credential_path}"
	profile					= "${var.aws_account_name}"
}

resource "aws_vpc" "my_vpc" {											# VPC configuration
	cidr_block = "${var.aws_vpc_addresses}"
	enable_dns_hostnames = true
	tags = {
		Name = "tf-aws"
	}
}

##########################################		NETWORK INTERFACES
resource "aws_subnet" "my_subnet" {										# subnet network which consists one network-interface 
	vpc_id            = "${aws_vpc.my_vpc.id}"
	cidr_block        = "${var.aws_vpc_subnet_addresses}"
	availability_zone = "${var.aws_region}a"
	map_public_ip_on_launch = true
	tags = {
    	Name = "tf-aws-subnet"
	}
}

resource "aws_network_interface" "component" {							# network-interface for INSTANCE
	subnet_id   = "${aws_subnet.my_subnet.id}"
	private_ips = "${var.aws_vpc_network_interface_addresses}"
	#security_groups = ["${aws_security_group.tf-sec-in.id}", "${aws_security_group.tf-sec-out.id}"]		# One of the variant of enabling security groups for network interface
	tags = {
    	Name = "primary_network_interface"
	}
}

resource "aws_internet_gateway" "tf-igw" {								# IGW (Internet GateWay) interface for VPC
	vpc_id		= "${aws_vpc.my_vpc.id}"
	tags = {
		Name	= "tf-igw"
	}
}
##########################################		NETWORK INTERFACE


##########################################		ROUTE TABLE
resource "aws_main_route_table_association" "tf-route-main" {
  vpc_id         = "${aws_vpc.my_vpc.id}"
  route_table_id = "${aws_route_table.tf-route.id}"
}
resource "aws_route_table" "tf-route" {									# Route table for VPC (routing of traffic from 0.0.0.0/0 to IGW interface)
	vpc_id = "${aws_vpc.my_vpc.id}"
	route {
    	cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.tf-igw.id}"
	}
	tags = {
		Name = "tf-main-route"
	}
}

##########################################		ROUTE TABLE


##########################################		SECURITY GROUPS PART			
resource "aws_security_group" "tf-sec-in" {
	name        = "tf-security-group-in"
	description = "Allow TLS inbound traffic"
	vpc_id      = "${aws_vpc.my_vpc.id}"
  	ingress {
    	# TLS (change to whatever ports you need)
    	from_port   = 0
    	to_port     = 0
    	protocol    = "-1"
		cidr_blocks = "${var.aws_security_group_ingress_addresses}"
	}
}
resource "aws_security_group" "tf-sec-out" {
	name        = "tf-security-group-out"
	description = "Allow all out communication traffic"
	vpc_id      = "${aws_vpc.my_vpc.id}"
  	egress {
		# TLS (change to whatever ports you need)
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = "${var.aws_security_group_egress_addresses}"
	}
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
	cidr_blocks = "${var.aws_security_group_ingress_addresses}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.aws_security_group_egress_addresses}"
  }
}
##########################################		SECURITY GROUPS PART


##########################################		IAM EC2 ROLE
resource "aws_iam_instance_profile" "tf-iam-role" {
  name = "tf-iam-role-instance"
  role = "${aws_iam_role.role.name}"
}
resource "aws_iam_role" "role" {
	name = "tf-iam-role"
	path = "/"

	assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "tf-policy-S3-read-only-policy-attachment" {
    role = "${aws_iam_role.role.name}"
    policy_arn = "${var.aws_iam_role_policy}"
}
##########################################		IAM EC2 ROLE



##########################################		INSTANCE PART	
resource "aws_instance" "web" {
	ami = "${var.aws_instance_aim}"
	availability_zone = "${var.aws_region}a"
	instance_type = "${var.aws_instance_machine_type}"
	key_name = "ec2-test"
	tags = {
    	Name = "terraform-aws"
	}
	network_interface {
   	network_interface_id = "${aws_network_interface.component.id}"
    	device_index     = 0
  	}
	root_block_device {
		volume_type				= "${var.aws_instance_volume_type}"
		volume_size				= "${var.aws_instance_volume_size}"
		delete_on_termination	= true
		encrypted				= false
	}
	iam_instance_profile = "${aws_iam_instance_profile.tf-iam-role.id}"
	connection {
                host= "${aws_instance.web.public_ip}"
                type= "ssh"
                user="ubuntu"
                agent = false
                private_key = "${file("~/Terraform-learn/aws/credentials/ec2-test.pem")}"		# path to private key for connection to ec2 instance
    }
	provisioner "remote-exec" {
                script = "files/deploy.sh"
    }
	timeouts{
		create	= "10m"
		update	= "10m"
		delete	= "24h"
	}
}


