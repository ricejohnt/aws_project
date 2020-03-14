resource "aws_cloudwatch_log_group" "hello_world" {
  name              = "hello_world_group"
  retention_in_days = 1
}
#
# resource "aws_cloudwatch_log_stream" "cw_hello" {
#   name           = "hello_world_stream"
#   log_group_name = aws_cloudwatch_log_group.hello_world.name
# }
