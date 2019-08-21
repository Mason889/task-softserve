############################    PROVIDER VARIABLES
variable "aws_region" {
    default         = "eu-west-2"                       # Region: London
}
variable "aws_account_credential_path" {
    default         = "/home/mason/.aws/credentials"    # path to user's aws_access_key & aws_secret_key
}
variable "aws_account_name" {
    default         = "terraform"                       # default aws account used for connecting to AWS environment
}


############################    VPC VARIABLES
variable "aws_vpc_addresses"{
    default         = "10.23.0.0/16"
}
variable "aws_vpc_subnet_addresses" {
    default         = "10.23.10.0/24"
}
variable "aws_vpc_network_interface_addresses" {
    default         = ["10.23.10.100"]                   # static ip address for network interface
}

############################    SECURITY GROUPS & ROLE
variable "aws_security_group_ingress_addresses" {
    default         = ["0.0.0.0/0"]                      # HERE you can write your personal IPs for more securiable connection, or leave default
}
variable "aws_security_group_egress_addresses" {
    default         = ["0.0.0.0/0"]                     # pool of address for output connection for ec2 instance
}
variable "aws_iam_role_policy" {
    default         = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"  # AWS policy which give infrastructure object access ONLY on listing and getting objects from AWS S3 bucket
}

############################    INSTANCE VARIABLES
variable "aws_instance_aim" {
    description     = "Amazon Machine Image - id of machine image"
    default         = "ami-8b0ee8ec"            # Ubuntu 16.04 ; AMI name: ami-ubuntu-16.04-1.9.5-00-1521756860
}
variable "aws_instance_machine_type" {
    default         = "t2.micro"                # default machine is t2.micro:  1 CPU & 1 GiB RAM
}
variable "aws_instance_volume_size" {
    default         = 10                        # 10 GiB - size of the volume for this instance
}
variable "aws_instance_volume_type" {
    default         = "gp2"                     
}



