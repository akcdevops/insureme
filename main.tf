resource "aws_instance" "main" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.public_subnets.id
    key_name = var.key_name
    associate_public_ip_address = true
    security_groups = [ aws_security_group.allow_tls.id ]
    tags = {
      Name = "${var.projectname}-${var.environment}-tomcatserver"
      Values = "tomcatserver"
    }
  
}
resource "aws_security_group" "allow_tls" {
  name        = "tomcat-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "tomcat-sg"
  }
}

# resource "aws_security_group" "dynamic_sg" {
#   for_each = var.config
#   name = "${each.key}-sg"
#   description = "The security group for ${each.key}"
#   vpc_id = aws_vpc.main.id

#     dynamic "ingress" {
#         for_each = each.value.ports[*]
#         content {
#             from_port   =  ingress.value.from
#             to_port     =  ingress.value.to
#             protocol    = "tcp"
#             cidr_blocks = ingress.value.from != 1433 ? [ ingress.value.source] : null 
#             ipv6_cidr_blocks= ingress.value.source== "0.0.0.0/0" ? [ingress.value.source] : null
#             security_groups =   ingress.value.from == 1433 ? [ ingress.value.source] : null 
#         }
#     }

#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = -1
#         cidr_blocks = ["0.0.0.0/0", "0.0.0.0/0"]
#     }

#   tags = {
#     "Name" = "${each.key}"
#     "Provider" = "Terraform"
#   }
# }
