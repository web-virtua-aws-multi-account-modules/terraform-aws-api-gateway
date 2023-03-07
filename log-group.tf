locals {
  tags_iam_role = {
    "Name"        = var.name
    "tf-iam-role" = var.name
    "tf-ou"       = var.ou_name
  }

  tags_log_group = {
    "Name"         = var.name
    "tf-log-group" = var.name
    "tf-ou"        = var.ou_name
  }
}

resource "aws_iam_role" "create_iam_role_api_gateway" {
  count = (var.api_gateway_assume_role_arn == null && var.resources_methods != null ? length(var.resources_methods) > 0 : false) ? 1 : 0

  name               = "${var.name}-trust-role"
  assume_role_policy = jsonencode(var.api_gateway_assume_role)
  description        = var.api_gateway_assume_role_description != null ? var.api_gateway_assume_role_description : "IAM assume role to: ${var.name}"
  tags               = merge(var.tags_iam_role, var.use_tags_default ? local.tags_iam_role : {})
}

resource "aws_api_gateway_account" "create_api_gateway_account" {
  count = var.resources_methods != null ? 1 : 0

  cloudwatch_role_arn = try(aws_iam_role.create_iam_role_api_gateway[0].arn, var.api_gateway_assume_role_arn, null)
}

resource "aws_iam_role_policy" "create_log_group_policy" {
  count = (var.make_log_group_policy && var.resources_methods != null ? length(var.resources_methods) > 0 : false) ? 1 : 0

  name   = "${var.name}-log-group"
  role   = try(aws_iam_role.create_iam_role_api_gateway[0].id, var.api_gateway_assume_role_id)
  policy = jsonencode(var.log_group_policy)
}

resource "aws_cloudwatch_log_group" "create_log_group" {
  count = (var.make_deployment && var.resources_methods != null ? length(var.resources_methods) > 0 : false) ? 1 : 0

  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.create_gateway_rest_api.id}/${aws_api_gateway_stage.create_api_gateway_stage[0].stage_name}"
  retention_in_days = var.log_group_retention_in_days
  tags              = merge(var.tags_log_gruup, var.use_tags_default ? local.tags_log_group : {})
}
