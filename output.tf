output "vpc_endpoints" {
  description = "VPC endpoints"
  value       = try(aws_vpc_endpoint.create_vpc_endpoint, null)
}

output "vpc_endpoints_ids" {
  description = "VPC endpoint IDs"
  value       = try(aws_vpc_endpoint.create_vpc_endpoint[*].id, null)
}

output "vpc_endpoints_arns" {
  description = "VPC endpoint ARNs"
  value       = try(aws_vpc_endpoint.create_vpc_endpoint[*].arn, null)
}

output "gateway_rest_api" {
  description = "Gateway rest API"
  value       = aws_api_gateway_rest_api.create_gateway_rest_api
}

output "gateway_rest_api_id" {
  description = "Gateway rest API ID"
  value       = aws_api_gateway_rest_api.create_gateway_rest_api.id
}

output "gateway_rest_api_arn" {
  description = "Gateway rest API ARN"
  value       = aws_api_gateway_rest_api.create_gateway_rest_api.arn
}

output "gateway_rest_api_execution_arn" {
  description = "Gateway rest API execution ARN"
  value       = aws_api_gateway_rest_api.create_gateway_rest_api.execution_arn
}

output "gateway_rest_api_root_resource_id" {
  description = "Gateway rest API root resource ID"
  value       = aws_api_gateway_rest_api.create_gateway_rest_api.root_resource_id
}

output "gateway_rest_api_endpoint_configuration" {
  description = "Gateway rest API endpoint configuration"
  value       = aws_api_gateway_rest_api.create_gateway_rest_api.endpoint_configuration
}

output "resources" {
  description = "Resources of API Gateway"
  value = concat(
    try(aws_api_gateway_resource.create_resources_root, []),
    try(aws_api_gateway_resource.create_resources_sub_1, []),
    try(aws_api_gateway_resource.create_resources_sub_2, []),
    try(aws_api_gateway_resource.create_resources_sub_3, []),
    try(aws_api_gateway_resource.create_resources_sub_4, [])
  )
}

output "methods" {
  description = "Methods of API Gateway"
  value       = try(aws_api_gateway_method.create_methods, null)
}

output "methods_reponses" {
  description = "Methods responses of API Gateway"
  value       = try(aws_api_gateway_method_response.create_method_responses, null)
}

output "integrations" {
  description = "Integration of API Gateway"
  value       = try(aws_api_gateway_integration.create_integrations, null)
}

output "integrations_reponses" {
  description = "Integration responses of API Gateway"
  value       = try(aws_api_gateway_integration_response.create_method_integration_responses, null)
}

output "lambda_permissions" {
  description = "Lambda permissions of API Gateway"
  value       = try(aws_lambda_permission.create_lambda_permissions, null)
}

output "api_gateway_deployment" {
  description = "API Gateway deployment of API Gateway"
  value       = try(aws_api_gateway_deployment.create_api_gateway_deployment[0], null)
}

output "api_gateway_deployment_id" {
  description = "API Gateway deployment ID of API Gateway"
  value       = try(aws_api_gateway_deployment.create_api_gateway_deployment[0].id, null)
}

output "api_gateway_deployment_invoke_url" {
  description = "API Gateway deployment invoke URL of API Gateway"
  value       = try(aws_api_gateway_deployment.create_api_gateway_deployment[0].invoke_url, null)
}

output "api_gateway_deployment_execution_arn" {
  description = "API Gateway deployment execution ARN of API Gateway"
  value       = try(aws_api_gateway_deployment.create_api_gateway_deployment[0].execution_arn, null)
}

output "api_gateway_stage" {
  description = "API Gateway stage of API Gateway"
  value       = try(aws_api_gateway_stage.create_api_gateway_stage[0], null)
}

output "api_gateway_stage_id" {
  description = "API Gateway stage ID of API Gateway"
  value       = try(aws_api_gateway_stage.create_api_gateway_stage[0].id, null)
}

output "api_gateway_stage_arn" {
  description = "API Gateway stage ARN of API Gateway"
  value       = try(aws_api_gateway_stage.create_api_gateway_stage[0].arn, null)
}

output "api_gateway_stage_invoke_url" {
  description = "API Gateway stage invoke URL of API Gateway"
  value       = try(aws_api_gateway_stage.create_api_gateway_stage[0].invoke_url, null)
}

output "api_gateway_authorizers" {
  description = "API Gateway authorizers"
  value       = try(aws_api_gateway_authorizer.api_gateway_authorizers, null)
}

output "api_gateway_authorizers_ids" {
  description = "API Gateway authorizers IDs"
  value       = try(aws_api_gateway_authorizer.api_gateway_authorizers[*].id, null)
}

output "api_gateway_authorizers_arns" {
  description = "API Gateway authorizers ARNs"
  value       = try(aws_api_gateway_authorizer.api_gateway_authorizers[*].arn, null)
}

output "method_settings" {
  description = "API Gateway method settings"
  value       = try(aws_api_gateway_method_settings.create_method_settings, null)
}

output "usage_plans" {
  description = "API Gateway usage plans"
  value       = try(aws_api_gateway_usage_plan.create_usage_plans, null)
}

output "api_keys" {
  description = "API Gateway API keys"
  value       = [for item in try(aws_api_gateway_api_key.create_api_keys, []) : merge(item, { value = null })]
}

### Domain ###
output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = try(module.create_acm_certificate[0].acm_certificate_arn, null)
}

output "acm_certificate_domain_validation_options" {
  description = "ACM certificate domain validation options"
  value       = try(module.create_acm_certificate[0].acm_certificate_domain_validation_options, null)
}

output "records_domain_validation" {
  description = "Records domain validation"
  value       = try(module.create_acm_certificate[0].records_domain_validation, null)
}

output "acm_certificate_validation" {
  description = "ACM certificate validation"
  value       = try(module.create_acm_certificate[0].acm_certificate_validation, null)
}

output "fqdn_records" {
  description = "List fqdn records"
  value       = try(module.create_acm_certificate[0].fqdn_records, null)
}

### Log Groups ###
output "iam_role_api_gateway" {
  description = "IAM role log group to API Gateway"
  value       = try(aws_iam_role.create_iam_role_api_gateway, null)
}

output "iam_role_api_gateway_id" {
  description = "IAM role log group ID to API Gateway"
  value       = try(aws_iam_role.create_iam_role_api_gateway[0].id, null)
}

output "iam_role_api_gateway_arn" {
  description = "IAM role log group ARN to API Gateway"
  value       = try(aws_iam_role.create_iam_role_api_gateway[0].arn, null)
}

output "api_gateway_account" {
  description = "API Gateway account"
  value       = try(aws_api_gateway_account.create_api_gateway_account, null)
}

output "log_group_policy" {
  description = "Log group policy"
  value       = try(aws_iam_role_policy.create_log_group_policy, null)
}

output "cloudwatch_log_group" {
  description = "Cloudwatch log group"
  value       = try(aws_cloudwatch_log_group.create_log_group, null)
}
