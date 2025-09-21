provider "aws"{
#	alias = "india"
	region = "ap-south-1"
}

resource "aws_vpc" "myvpc"{
	cidr_block = "10.0.0.0/16"
}

#subnets

resource "aws_subnet" "public1"{
	vpc_id = aws_vpc.myvpc.id
	cidr_block = "10.0.0.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "ap-south-1b"
	tags = {
		name = "public1"
}
}

resource "aws_subnet" "public2"{
        vpc_id = aws_vpc.myvpc.id
        cidr_block = "10.0.62.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "ap-south-1a"
        tags = { 
                name = "public2"
}
}
#Internet gateway
resource "aws_internet_gateway" "igw"{
	vpc_id = aws_vpc.myvpc.id
	tags = {
		name = "project"	
}
}

#route table
resource "aws_route_table" "route"{
	vpc_id = aws_vpc.myvpc.id
	 route {
   		 cidr_block = "0.0.0.0/0"
    		 gateway_id = aws_internet_gateway.igw.id
  }

}

#route table and subnet association
resource "aws_route_table_association" "route-table" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.route.id
}

#security group
resource "aws_security_group" "asg"{
        description = "Allowing HTTP and SSH"
	vpc_id      = aws_vpc.myvpc.id
        ingress{
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
}
        ingress{
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
}
        egress{
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
}
}

#ec2 instance
resource "aws_instance" "myec2"{
        ami = var.ami_id
        instance_type = "t2.micro"
        subnet_id = aws_subnet.public1.id
        key_name = "LinuxKey1"
	vpc_security_group_ids = [aws_security_group.asg.id]
	user_data = <<EOF
#!/bin/bash
apt update
apt install apache2 -y
chmod 777 -R /var/www/html
echo "Created this project in Terraform from VPC --> EC2" >> /var/www/html/index.html
EOF
        tags = {
                Name = "ec2"
}
}

#output
output "public_IP_address"{
	value = aws_instance.myec2.public_ip
}

