resource "aws_vpc_endpoint" "create_vpc_endpoint" {
  count = var.api_vpc_endpoint_ids == null ? var.vpc_endpoint_quantity_create : 0

  private_dns_enabled = var.private_dns_enabled
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  vpc_endpoint_type   = var.vpc_endpoint_type
  service_name        = var.vpc_service_name != null ? var.vpc_service_name : "com.amazonaws.${var.region}.execute-api"
}

resource "aws_api_gateway_rest_api" "create_gateway_rest_api" {
  name        = var.name
  description = var.description

  endpoint_configuration {
    types            = var.endpoint_configuration_types
    vpc_endpoint_ids = length(aws_vpc_endpoint.create_vpc_endpoint) > 0 ? aws_vpc_endpoint.create_vpc_endpoint[*].id : var.api_vpc_endpoint_ids != null ? var.api_vpc_endpoint_ids : null
  }
}

### Resources levels ###
resource "aws_api_gateway_resource" "create_resources_root" {
  count = length(local.resources_root)

  rest_api_id = aws_api_gateway_rest_api.create_gateway_rest_api.id
  parent_id   = aws_api_gateway_rest_api.create_gateway_rest_api.root_resource_id
  path_part   = local.resources_root[count.index].path_part
}

resource "aws_api_gateway_resource" "create_resources_sub_1" {
  count = length(local.resources_sub_1)

  rest_api_id = aws_api_gateway_rest_api.create_gateway_rest_api.id
  parent_id   = aws_api_gateway_resource.create_resources_root[local.resources_sub_1[count.index].previous_level].id
  path_part   = local.resources_sub_1[count.index].path_part

  depends_on = [
    aws_api_gateway_resource.create_resources_root
  ]
}

resource "aws_api_gateway_resource" "create_resources_sub_2" {
  count = length(local.resources_sub_2)

  rest_api_id = aws_api_gateway_rest_api.create_gateway_rest_api.id
  parent_id   = aws_api_gateway_resource.create_resources_sub_1[local.resources_sub_2[count.index].previous_level].id
  path_part   = local.resources_sub_2[count.index].path_part

  depends_on = [
    aws_api_gateway_resource.create_resources_sub_1
  ]
}

resource "aws_api_gateway_resource" "create_resources_sub_3" {
  count = length(local.resources_sub_3)

  rest_api_id = aws_api_gateway_rest_api.create_gateway_rest_api.id
  parent_id   = aws_api_gateway_resource.create_resources_sub_2[local.resources_sub_3[count.index].previous_level].id # -2
  path_part   = local.resources_sub_3[count.index].path_part

  depends_on = [
    aws_api_gateway_resource.create_resources_sub_2
  ]
}

resource "aws_api_gateway_resource" "create_resources_sub_4" {
  count = length(local.resources_sub_4)

  rest_api_id = aws_api_gateway_rest_api.create_gateway_rest_api.id
  parent_id   = aws_api_gateway_resource.create_resources_sub_3[local.resources_sub_4[count.index].previous_level].id # -3
  path_part   = local.resources_sub_4[count.index].path_part

  depends_on = [
    aws_api_gateway_resource.create_resources_sub_3
  ]
}

# ### Methods ###
resource "aws_api_gateway_method" "create_methods" {
  count = length(local.methods)

  rest_api_id          = aws_api_gateway_rest_api.create_gateway_rest_api.id
  resource_id          = local.methods[count.index].index_level == 0 ? aws_api_gateway_resource.create_resources_root[local.methods[count.index].index].id : local.methods[count.index].index_level == 1 ? aws_api_gateway_resource.create_resources_sub_1[local.methods[count.index].index].id : local.methods[count.index].index_level == 2 ? aws_api_gateway_resource.create_resources_sub_2[local.methods[count.index].index].id : local.methods[count.index].index_level == 3 ? aws_api_gateway_resource.create_resources_sub_3[local.methods[count.index].index].id : aws_api_gateway_resource.create_resources_sub_4[local.methods[count.index].index].id
  http_method          = local.methods[count.index].http_method
  authorization        = local.methods[count.index].authorization_method
  authorizer_id        = local.methods[count.index].authorizer_id_external != null ? local.methods[count.index].authorizer_id_external : local.methods[count.index].authorizer_id_index != null ? try(aws_api_gateway_authorizer.api_gateway_authorizers[local.methods[count.index].authorizer_id_index].id, "") : ""
  request_parameters   = try(local.methods[count.index].request_parameters_method, null)
  authorization_scopes = local.methods[count.index].authorization_scopes_method
  api_key_required     = local.methods[count.index].api_key_required_method
  operation_name       = local.methods[count.index].operation_name_method
  request_models       = local.methods[count.index].request_models_method
  request_validator_id = local.methods[count.index].request_validator_id_method

  depends_on = [
    aws_api_gateway_resource.create_resources_root,
    aws_api_gateway_resource.create_resources_sub_1,
    aws_api_gateway_resource.create_resources_sub_2,
    aws_api_gateway_resource.create_resources_sub_3,
    aws_api_gateway_resource.create_resources_sub_4,
  ]
}

resource "aws_api_gateway_method_response" "create_method_responses" {
  count = length(local.method_responses)

  rest_api_id         = aws_api_gateway_rest_api.create_gateway_rest_api.id
  resource_id         = aws_api_gateway_method.create_methods[local.method_responses[count.index].index_method].resource_id
  http_method         = aws_api_gateway_method.create_methods[local.method_responses[count.index].index_method].http_method
  status_code         = local.method_responses[count.index].method_response.status_code
  response_models     = local.method_responses[count.index].method_response.response_models
  response_parameters = local.method_responses[count.index].method_response.response_parameters

  depends_on = [
    aws_api_gateway_integration.create_integrations
  ]
}

### Integrations ###
resource "aws_api_gateway_integration" "create_integrations" {
  count = length(local.methods)

  rest_api_id             = aws_api_gateway_rest_api.create_gateway_rest_api.id
  resource_id             = aws_api_gateway_method.create_methods[count.index].resource_id
  http_method             = aws_api_gateway_method.create_methods[count.index].http_method
  integration_http_method = local.methods[count.index].http_method_integration
  type                    = local.methods[count.index].type_integration
  uri                     = local.methods[count.index].uri_integration
  request_parameters      = local.methods[count.index].request_parameters_integration

  passthrough_behavior = local.methods[count.index].passthrough_behavior_integration
  content_handling     = local.methods[count.index].content_handling_integration
  connection_type      = local.methods[count.index].connection_type_integration
  connection_id        = local.methods[count.index].connection_id_integration
  request_templates    = local.methods[count.index].request_templates_integration

  credentials          = local.methods[count.index].credentials_integration
  cache_key_parameters = local.methods[count.index].cache_key_parameters_integration
  cache_namespace      = local.methods[count.index].cache_namespace_integration
  timeout_milliseconds = local.methods[count.index].timeout_milliseconds_integration

  dynamic "tls_config" {
    for_each = local.methods[count.index].tls_config_integration != null ? [1] : []

    content {
      insecure_skip_verification = local.methods[count.index].tls_config_integration
    }
  }

  depends_on = [
    aws_api_gateway_method.create_methods
  ]
}

resource "aws_api_gateway_integration_response" "create_method_integration_responses" {
  count = length(local.integration_responses)

  rest_api_id         = aws_api_gateway_rest_api.create_gateway_rest_api.id
  resource_id         = aws_api_gateway_method.create_methods[local.integration_responses[count.index].index_method].resource_id
  http_method         = aws_api_gateway_method.create_methods[local.integration_responses[count.index].index_method].http_method
  status_code         = local.integration_responses[count.index].integration_response.status_code
  response_templates  = local.integration_responses[count.index].integration_response.response_templates
  content_handling    = local.integration_responses[count.index].integration_response.content_handling
  response_parameters = local.integration_responses[count.index].integration_response.response_parameters
  selection_pattern   = local.integration_responses[count.index].integration_response.selection_pattern

  depends_on = [
    aws_api_gateway_method_response.create_method_responses,
    aws_api_gateway_deployment.create_api_gateway_deployment
  ]
}

### Lambda permissions ###
resource "aws_lambda_permission" "create_lambda_permissions" {
  count = var.make_lambda_permissions ? length(var.lambda_permission_api) : 0

  statement_id           = var.lambda_permission_api[count.index].statement_id != null ? var.lambda_permission_api[count.index].statement_id : "${var.name}-lambda-permission"
  function_name          = var.lambda_permission_api[count.index].function_name != null ? var.lambda_permission_api[count.index].function_name : var.lambda_function_name
  source_arn             = var.lambda_permission_api[count.index].source_arn != null ? var.lambda_permission_api[count.index].source_arn : "${aws_api_gateway_rest_api.create_gateway_rest_api.execution_arn}/*/*"
  action                 = var.lambda_permission_api[count.index].action
  principal              = var.lambda_permission_api[count.index].principal
  qualifier              = var.lambda_permission_api[count.index].qualifier
  event_source_token     = var.lambda_permission_api[count.index].qualifier
  function_url_auth_type = var.lambda_permission_api[count.index].qualifier
  source_account         = var.lambda_permission_api[count.index].qualifier
  principal_org_id       = var.lambda_permission_api[count.index].qualifier
}

### Deployment ###
resource "aws_api_gateway_deployment" "create_api_gateway_deployment" {
  count = (var.make_deployment && var.resources_methods != null) ? 1 : 0

  rest_api_id       = aws_api_gateway_rest_api.create_gateway_rest_api.id
  description       = var.deployment_description
  stage_name        = var.deployment_stage_name
  stage_description = var.deployment_stage_description
  variables         = var.deployment_variables

  triggers = {
    redeployment = sha1(jsonencode(compact(concat(
      try(aws_api_gateway_resource.create_resources_root[*].id, ""),
      try(aws_api_gateway_resource.create_resources_sub_1[*].id, ""),
      try(aws_api_gateway_resource.create_resources_sub_2[*].id, ""),
      try(aws_api_gateway_resource.create_resources_sub_3[*].id, ""),
      try(aws_api_gateway_resource.create_resources_sub_4[*].id, ""),
      try(aws_api_gateway_method.create_methods[*].id, ""),
      try(aws_api_gateway_integration.create_integrations[*].id, ""),
      try(aws_api_gateway_method_response.create_method_responses[*].id, ""),
      # try(aws_api_gateway_integration_response.create_method_integration_response[*].id, ""),
    ))))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_resource.create_resources_root,
    aws_api_gateway_resource.create_resources_sub_1,
    aws_api_gateway_resource.create_resources_sub_2,
    aws_api_gateway_resource.create_resources_sub_3,
    aws_api_gateway_resource.create_resources_sub_4,
    aws_api_gateway_method.create_methods,
    aws_api_gateway_integration.create_integrations,
    aws_api_gateway_method_response.create_method_responses
  ]
}

resource "aws_api_gateway_stage" "create_api_gateway_stage" {
  count = (var.make_deployment && var.resources_methods != null) ? 1 : 0

  rest_api_id           = aws_api_gateway_rest_api.create_gateway_rest_api.id
  deployment_id         = aws_api_gateway_deployment.create_api_gateway_deployment[0].id
  stage_name            = var.stage_name
  tags                  = merge(var.tags_stage, var.use_tags_default ? local.tags_stage : {})
  cache_cluster_enabled = try(var.stage_extra_settings.cache_cluster_enabled, null)
  cache_cluster_size    = try(var.stage_extra_settings.cache_cluster_size, null)
  client_certificate_id = try(var.stage_extra_settings.client_certificate_id, null)
  description           = try(var.stage_extra_settings.description, null)
  documentation_version = try(var.stage_extra_settings.documentation_version, null)
  variables             = try(var.stage_extra_settings.variables, null)
  xray_tracing_enabled  = try(var.stage_extra_settings.xray_tracing_enabled, null)

  depends_on = [
    aws_api_gateway_deployment.create_api_gateway_deployment
  ]
}

# ### Authorizers ###
resource "aws_api_gateway_authorizer" "api_gateway_authorizers" {
  count = var.api_gateway_authorizers != null ? length(var.api_gateway_authorizers) : 0

  rest_api_id                      = aws_api_gateway_rest_api.create_gateway_rest_api.id
  name                             = var.api_gateway_authorizers[count.index].name
  type                             = var.api_gateway_authorizers[count.index].type
  authorizer_uri                   = var.api_gateway_authorizers[count.index].authorizer_uri
  authorizer_credentials           = var.api_gateway_authorizers[count.index].authorizer_credentials
  authorizer_result_ttl_in_seconds = var.api_gateway_authorizers[count.index].authorizer_result_ttl_in_seconds
  identity_source                  = var.api_gateway_authorizers[count.index].identity_source
  identity_validation_expression   = var.api_gateway_authorizers[count.index].identity_validation_expression
  provider_arns                    = var.api_gateway_authorizers[count.index].provider_arns
}

### API Gateway Settings ###
resource "aws_api_gateway_method_settings" "create_method_settings" {
  count = var.method_settings != null ? ((var.make_deployment && var.resources_methods != null) ? length(var.resources_methods) > 0 : false) ? 1 : 0 : 0

  rest_api_id = aws_api_gateway_rest_api.create_gateway_rest_api.id
  stage_name  = aws_api_gateway_stage.create_api_gateway_stage[0].stage_name
  method_path = var.method_settings.method_path

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled    = var.method_settings.metrics_enabled
    data_trace_enabled = var.method_settings.data_trace_enabled
    logging_level      = var.method_settings.logging_level
    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit                      = var.method_settings.throttling_rate_limit
    throttling_burst_limit                     = var.method_settings.throttling_burst_limit
    caching_enabled                            = var.method_settings.caching_enabled
    cache_ttl_in_seconds                       = var.method_settings.cache_ttl_in_seconds
    cache_data_encrypted                       = var.method_settings.cache_data_encrypted
    require_authorization_for_cache_control    = var.method_settings.require_authorization_for_cache_control
    unauthorized_cache_control_header_strategy = var.method_settings.unauthorized_cache_control_header_strategy
  }

  depends_on = [
    aws_cloudwatch_log_group.create_log_group,
    aws_api_gateway_stage.create_api_gateway_stage
  ]
}

### Usage Plans ###
resource "aws_api_gateway_usage_plan" "create_usage_plans" {
  count = var.use_plans_api_keys != null ? length(var.use_plans_api_keys) : 0

  name         = var.use_plans_api_keys[count.index].name
  description  = var.use_plans_api_keys[count.index].description
  product_code = var.use_plans_api_keys[count.index].product_code

  api_stages {
    api_id = aws_api_gateway_rest_api.create_gateway_rest_api.id
    stage  = aws_api_gateway_stage.create_api_gateway_stage[0].stage_name
  }

  quota_settings {
    limit  = var.use_plans_api_keys[count.index].quota_limit
    offset = var.use_plans_api_keys[count.index].quota_offset
    period = var.use_plans_api_keys[count.index].quota_period
  }

  throttle_settings {
    burst_limit = var.use_plans_api_keys[count.index].throttle_burst_limit
    rate_limit  = var.use_plans_api_keys[count.index].throttle_rate_limit
  }

  tags = merge(var.tags_use_plans, var.use_tags_default ? {
    "Name"         = "${var.name}-${count.index}"
    "tf-use-plans" = "${var.name}-${count.index}"
    "tf-ou"        = var.ou_name
  } : {})
}

resource "aws_api_gateway_api_key" "create_api_keys" {
  count = local.api_keys != null ? length(local.api_keys) : 0

  name        = local.api_keys[count.index].key.name
  description = local.api_keys[count.index].key.description
  enabled     = local.api_keys[count.index].key.enabled
  value       = local.api_keys[count.index].key.value

  tags = merge(var.tags_api_keys, var.use_tags_default ? {
    "Name"       = "${var.name}-${count.index}"
    "tf-api-key" = "${var.name}-${count.index}"
    "tf-ou"      = var.ou_name
  } : {})

  depends_on = [
    aws_api_gateway_usage_plan.create_usage_plans
  ]
}

resource "aws_api_gateway_usage_plan_key" "create_attach_api_key_usage_plan" {
  count = local.api_keys != null ? length(local.api_keys) : 0

  key_type      = "API_KEY"
  key_id        = aws_api_gateway_api_key.create_api_keys[count.index].id
  usage_plan_id = aws_api_gateway_usage_plan.create_usage_plans[local.api_keys[count.index].index].id

  depends_on = [
    aws_api_gateway_api_key.create_api_keys
  ]
}
