# region variable
variable "region" {
  type = string # Welcher Datentyp ist die Variable?
  default = "eu-central-1" # Welchen Wert hat die Variable, wenn nichts angegeben wird?
}

# userprofile variable
variable "aws_profile" {
  type = string # Welcher Datentyp ist die Variable?
  default = "techstarter" # Welchen Wert hat die Variable, wenn nichts angegeben wird?
}

# vpc variable
variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

# subnet variable
variable "public_subnets_cidr" {
  description = "List of subnets"
}

# availability zones variable
variable "availability_zones" {
  description = "List of availability zones"
}