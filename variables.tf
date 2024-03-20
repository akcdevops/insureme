variable "projectname" {
    description = "This varaible declares the project name "
    type = string
}

variable "environment" {
    description = "This varaible declares the environmnet "
    type = string
}

variable "region" {
    description = "This varaible declares the region "
    type = string
}

variable "instance_type" {
    description = "This varaible declares the region "
    type = string
}
variable "key_name" {
description = "This variable indicates key_pair_name"
type = string
}
variable "ami_id" {
   description = "This variable indicates ami id"
   type = string
}
variable "public_key" {
description = "This variable indicates public_key"
type = string
}

variable "cidr_block" {
    description = "This variable indicates declaring of vpc cide block value"
    type = string
}

variable "cidr_public_subnet" {
  
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
 
  description = "Private Subnet CIDR values"
}

variable "availability_zone" {
  
  description = "Availability Zones"
}


variable "config" {
   default = {
    "tomcat" = {
       ports  = [
        {
          from = 22
          to = 22
          source="0.0.0.0/0"
        },
        {
          from = 80
          to = 80
          source="0.0.0.0/0"
        },
         {
          from = 443
          to = 443
          source="0.0.0.0/0"
        },
        {
          from = 8080
          to = 8080
          source ="0.0.0.0/0"
        }
      ]
    },
     
   } 
 }


