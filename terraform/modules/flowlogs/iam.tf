resource "aws_iam_role" "flow_logs_role"{
  provider         = aws
  name = "shared-services-vpc-flow-logs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
       }
     ]
   })
  tags = merge(var.tags, {
    Name = "AWS Shared Services"
  })
}
resource "aws_iam_role_policy" "flow_logs_policy"{
  provider         = aws
  name = "vpc-flow-logs-policy"
  role =aws_iam_role.flow_logs_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
        ]
        Effect="Allow"
        Resource = "*"
      }
    ]
  })
}                                                                             