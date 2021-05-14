resource "aws_flow_log" "pc_flow" {
  iam_role_arn    = aws_iam_role.pc_flow_role.arn
  log_destination = aws_cloudwatch_log_group.pc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.sandbox.id
}

resource "aws_cloudwatch_log_group" "pc_flow_log" {
  name = "pc_flow_log"
}