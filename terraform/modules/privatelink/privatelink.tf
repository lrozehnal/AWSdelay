resource "aws_security_group" "SG-nlb" {
   provider = aws.nlb
  vpc_id   = var.vpc_id
  tags = merge(var.tags, {
    Name = "EC2 SG"
  })

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict!                                                                                                                                                                                                                                                                               
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict!                                                                                                                                                                                                                                                                               
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "SG-client" {
   provider = aws.client
  vpc_id   = var.client_vpc_id
  tags = merge(var.tags, {
    Name = "EC2 SG"
  })

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict!                                                                                                                                                                                                                                                                               
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict!                                                                                                                                                                                                                                                                               
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "nlb" {
name        = "${var.name}-${var.nlbregion}-NLB"
   provider = aws.nlb
   internal           = true
   load_balancer_type = "network"
   subnets            = var.subnets_id
   ip_address_type    = "ipv4"


   tags = var.tags
 }

 resource "aws_lb_target_group" "tg" {
   name        = "${var.name}-${var.nlbregion}-TG"
   provider = aws.nlb
   port        = var.tg_port
   protocol    = var.protocol
   vpc_id      = var.vpc_id
   target_type = "ip"
   
   health_check {
     protocol = var.protocol
     #port     = var.tg_port
     port     = "22"
     #port     = "5201"
     healthy_threshold = 2
   }
   
   tags = var.tags
 }

resource "aws_lb_listener" "listener-tcp" {
   load_balancer_arn = aws_lb.nlb.arn
   provider = aws.nlb
   port              = var.listener_port
   protocol          = var.protocol
   default_action {
     type             = "forward"
     target_group_arn = aws_lb_target_group.tg.arn
   }                                                                                                                                                          
 }                                                                                                                                                            

 resource "aws_lb_target_group_attachment" "attach" {     
  provider = aws.nlb                                                                                                       
   target_group_arn = aws_lb_target_group.tg.arn                                                                                                            
   target_id        = var.target_ip                                                                                                              
   port             = var.tg_port
   availability_zone = "all"                                                                                                                         
 }                                                                                                                                                            



resource "aws_vpc_endpoint_service" "endpointservice" {  
  provider         = aws.nlb
  private_dns_name = "${var.name}.${var.domain}"
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.nlb.arn]
  supported_regions = ["ap-southeast-2",var.nlbregion]
  tags = merge(var.tags, {
    Name = var.name
  })
}

 data "aws_route53_zone" "dnszone" {
   provider = aws.nlb
   name = var.domain
   private_zone = false
 }

resource "aws_route53_record" "verifingTXT" {
  provider = aws.nlb
  zone_id = data.aws_route53_zone.dnszone.id
  name =  aws_vpc_endpoint_service.endpointservice.private_dns_name_configuration[0].name
  type = "TXT"
  ttl     = "300"
  records = [ aws_vpc_endpoint_service.endpointservice.private_dns_name_configuration[0].value]
}


resource "aws_vpc_endpoint_service_private_dns_verification" "endpointservice_dns_verification" {
  provider         = aws.nlb
  service_id = aws_vpc_endpoint_service.endpointservice.id
  depends_on =  [aws_route53_record.verifingTXT]
}






resource  "aws_vpc_endpoint" "endpoint" {
  provider = aws.client
  service_name = aws_vpc_endpoint_service.endpointservice.service_name
  vpc_id            = var.client_vpc_id
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.client_subnets_id
  private_dns_enabled = "true"
  service_region = var.nlbregion 
  security_group_ids = [aws_security_group.SG-client.id] 
  tags = merge(var.tags, {
    Name = var.name
  })
}
