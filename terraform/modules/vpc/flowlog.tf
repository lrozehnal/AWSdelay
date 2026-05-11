/*

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  provider         = aws
  name = "AWS-VPC-flowlogs"
  tags = merge(var.tags, {
    Name = var.name
  })
}


resource "aws_flow_log" "vpc_flow_log" {
  provider         = aws
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id            = aws_vpc.vpc.id
  
  iam_role_arn = var.flowlog_iam_role
  max_aggregation_interval = 60
}

*/