/*
variable "key" {                                                                                                                                                                                                                                                                                                           
   description = "AWS Key Pair object"                                                                                                                                                                                                                                                                                      
   type = object({                                                                                                                                                                                                                                                                                                          
     id         = optional(string)                                                                                                                                                                                                                                                                                          
     key_name   = string                                                                                                                                                                                                                                                                                                    
     arn        = optional(string)                                                                                                                                                                                                                                                                                          
     fingerprint = optional(string)                                                                                                                                                                                                                                                                                         
     public_key = optional(string)                                                                                                                                                                                                                                                                                          
   })                                                                                                                                                                                                                                                                                                                       
 }                  
*/
variable "public_key" {  
  type= string
}
variable "key_name" {  
  type= string
}
variable "vpc_id" {
  type = string
}

variable "subnets_id" {
  type = list
}

variable "name" {
  type = string
}

variable "domain" {
  type = string
}
variable "tags" {
  type = map(any)
}
