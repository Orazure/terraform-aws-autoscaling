variable "aws_region" {
  type        = string
  description = "AWS Region"
  default = "us-east-1"
}


# variable "availability_zones" {
#   type        = map(string)
#   description = "Availability Zones"
  
# }

variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default = "CloudTp"
}



variable "app_name" {
  type        = string
  default = "AppTest"
}

variable "key" {
  type        = string
  description = "Key"
  default = "auth_key_pair"
  
}
  

  

