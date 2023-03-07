variable "name" {
  description = "API Gateway name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Lambda function name to be access for API Gateway"
  type        = string
  default     = null
}

variable "stage_name" {
  description = "Stage name to API Gateway deployment, ex: v1, v2..."
  type        = string
  default     = null
}

variable "deployment_stage_name" {
  description = "Deployment stage name to API Gateway deployment"
  type        = string
  default     = null
}

variable "deployment_stage_description" {
  description = "Deployment stage description to API Gateway deployment"
  type        = string
  default     = null
}

variable "deployment_description" {
  description = "Deployment description to API Gateway deployment"
  type        = string
  default     = null
}

variable "deployment_variables" {
  description = "Deployment variables to API Gateway deployment"
  type        = map(any)
  default     = null
}

variable "description" {
  description = "API Gateway description"
  type        = string
  default     = "API Gateway"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet ID's"
  type        = list(string)
  default     = null
}

variable "security_group_ids" {
  description = "Security groups ids"
  type        = list(string)
  default     = null
}

variable "vpc_endpoint_quantity_create" {
  description = "Quantity of the new vpc endpoint to create"
  type        = number
  default     = 0
}

variable "api_vpc_endpoint_ids" {
  description = "If defined will be used in a API rest"
  type        = list(string)
  default     = null
}

variable "private_dns_enabled" {
  description = "Private DNS enabled"
  type        = bool
  default     = false
}

variable "vpc_endpoint_type" {
  description = "VPC endpoint type"
  type        = string
  default     = "Interface"
}

variable "vpc_service_name" {
  description = "VPC service name"
  type        = string
  default     = null
}

variable "endpoint_configuration_types" {
  description = "Endpoint configuration types"
  type        = list(string)
  default     = ["REGIONAL"]
}

variable "ou_name" {
  description = "Organization unit name"
  type        = string
  default     = "no"
}

variable "use_tags_default" {
  description = "If true will be use the tags default"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to API Gateway"
  type        = map(any)
  default     = {}
}

variable "tags_domain_names" {
  description = "Tags to api gateway domain names"
  type        = map(any)
  default     = {}
}

variable "tags_iam_role" {
  description = "Tags to IAM role"
  type        = map(any)
  default     = {}
}

variable "tags_log_gruup" {
  description = "Tags to Cloudwatch log group"
  type        = map(any)
  default     = {}
}

variable "tags_stage" {
  description = "Tags to stage"
  type        = map(any)
  default     = {}
}

variable "tags_use_plans" {
  description = "Tags to use plans"
  type        = map(any)
  default     = {}
}

variable "tags_api_keys" {
  description = "Tags to API Keys"
  type        = map(any)
  default     = {}
}

variable "stage_extra_settings" {
  description = "Stage extra settings to API Gateway deployment"
  type = object({
    cache_cluster_enabled = optional(bool)
    cache_cluster_size    = optional(string)
    client_certificate_id = optional(string)
    description           = optional(string)
    documentation_version = optional(string)
    variables             = optional(map(any))
    xray_tracing_enabled  = optional(bool)
  })
  default = null
}

variable "api_gateway_authorizers" {
  description = "List of Cognito API Gateway authorizers"
  type = list(object({
    name                             = string
    provider_arns                    = list(string)
    type                             = optional(string)
    authorizer_uri                   = optional(string)
    identity_source                  = optional(string)
    authorizer_credentials           = optional(string)
    identity_validation_expression   = optional(string)
    authorizer_result_ttl_in_seconds = optional(number)
  }))
  default = null
}

variable "resources_methods" {
  description = "List of resources that represent the path configurations to enpoints"
  type = list(object({
    path                 = string
    method_all_sub_paths = optional(bool) # If true all sub paths will have method
    methods = optional(list(object({
      http_method                      = optional(string)
      http_method_integration          = optional(string)
      type_integration                 = optional(string)
      uri_integration                  = optional(string)
      request_parameters_integration   = optional(map(any))
      passthrough_behavior_integration = optional(string)
      content_handling_integration     = optional(string)
      connection_type_integration      = optional(string)
      connection_id_integration        = optional(string)
      request_templates_integration    = optional(map(any))

      credentials_integration          = optional(string)
      cache_key_parameters_integration = optional(list(string))
      cache_namespace_integration      = optional(string)
      timeout_milliseconds_integration = optional(number)
      tls_config_integration           = optional(bool)
    })))
    http_method               = optional(string)
    authorization_method      = optional(string)
    request_parameters_method = optional(map(any))
    authorizer_id_external    = optional(string) # To set one authorizer external
    authorizer_id_index       = optional(number) # If more than one authorizer choosing for the index
    # integration
    http_method_integration        = optional(string)
    type_integration               = optional(string)
    uri_integration                = optional(string)
    request_parameters_integration = optional(map(any))
    # others configurations
    authorization_scopes_method      = optional(list(string))
    api_key_required_method          = optional(bool)
    operation_name_method            = optional(string)
    request_models_method            = optional(map(any))
    request_validator_id_method      = optional(string)
    passthrough_behavior_integration = optional(string)
    content_handling_integration     = optional(string)
    connection_type_integration      = optional(string)
    connection_id_integration        = optional(string)
    request_templates_integration    = optional(map(any))
    credentials_integration          = optional(string)
    cache_key_parameters_integration = optional(list(string))
    cache_namespace_integration      = optional(string)
    timeout_milliseconds_integration = optional(number)
    tls_config_integration           = optional(bool)
    # responses
    responses = optional(object({
      methods = optional(list(object({
        status_code         = string
        response_models     = optional(map(any))
        response_parameters = optional(map(any))
      })))
      integrations = optional(list(object({
        status_code         = string
        selection_pattern   = optional(string)
        response_templates  = optional(map(any))
        content_handling    = optional(string)
        response_parameters = optional(map(any))
      })))
    }))
  }))
  default = null
}

variable "lambda_permission_api" {
  description = "List with lambda functions that give allow access to API Gateway"
  type = list(object({
    action                 = optional(string, "lambda:InvokeFunction")
    principal              = optional(string, "apigateway.amazonaws.com")
    statement_id           = optional(string, null)
    function_name          = optional(string, null)
    source_arn             = optional(string, null)
    qualifier              = optional(string, null)
    event_source_token     = optional(string, null)
    function_url_auth_type = optional(string, null)
    source_account         = optional(string, null)
    principal_org_id       = optional(string, null)
    description            = optional(string, null)
  }))
  default = [{
    action    = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
  }]
}

variable "method_settings" {
  description = "Method settings to configuration logs"
  type = object({
    logging_level                              = string
    method_path                                = optional(string, "*/*")
    metrics_enabled                            = optional(bool, true)
    data_trace_enabled                         = optional(bool, true)
    throttling_rate_limit                      = optional(number, 100)
    throttling_burst_limit                     = optional(number, 50)
    caching_enabled                            = optional(bool, null)
    cache_ttl_in_seconds                       = optional(number, null)
    cache_data_encrypted                       = optional(bool, null)
    require_authorization_for_cache_control    = optional(bool, null)
    unauthorized_cache_control_header_strategy = optional(string, null)
  })
  default = null
}

variable "use_plans_api_keys" {
  description = "List with all the use plans and API keys to be used in API Gateway"
  type = list(object({
    name                 = string
    quota_limit          = number
    quota_period         = string
    quota_offset         = optional(number)
    description          = optional(string)
    product_code         = optional(string)
    throttle_burst_limit = optional(number, 5)
    throttle_rate_limit  = optional(number, 10)
    tags                 = optional(map(any))
    keys = list(object({
      name        = string
      description = optional(string)
      enabled     = optional(bool, true)
      value       = optional(string)
      tags        = optional(map(any))
    }))
  }))
  default = null
}

##################################################
#################### Domain ######################
variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID domain, ex: Z0820...QYIK"
  type        = string
  default     = null
}

variable "hosted_zone_name" {
  description = "Route 53 hosted zone name domain, ex: exemple.com"
  type        = string
  default     = null
}

variable "master_domain" {
  description = "Master domain that received request and redirect to API Gateway, ex: test.exemple.com"
  type        = string
  default     = null
}

variable "alternatives_domains" {
  description = "Alternatives domais that will be redirec to same API Gateway"
  type        = list(string)
  default     = null
}

variable "endpoint_configuration_type" {
  description = "Endpoint configuration type to API Gateway domain name, can be EDGE or REGIONAL"
  type        = list(string)
  default     = ["REGIONAL"]
}

variable "security_policy" {
  description = "Transport Layer Security (TLS) version + cipher suite for this DomainName, can be TLS_1_0 or TLS_1_2"
  type        = string
  default     = null
}

variable "make_acm_certificate" {
  description = "If true will be created the ACM and fqdn records"
  type        = bool
  default     = true
}

variable "make_records" {
  description = "If true will be created the records redirecting to API Gateway, is make_acm_certificate variable is required in this configuration"
  type        = bool
  default     = true
}

variable "make_deployment" {
  description = "If true will be created a deployment and resources associates"
  type        = bool
  default     = true
}

variable "make_lambda_permissions" {
  description = "If true will be created a lambda permissions to API Gateway"
  type        = bool
  default     = true
}

variable "domain_path_mapping_new_version" {
  description = "This variable define a new version in the custom domains, using the same DNS, but mapping to a new API Gateway, ex: exemple.com/v2, if used the make_acm_certificate variables should be set as true"
  type = object({
    base_path    = string
    domain_names = list(string)
  })
  default = null
}

##################################################
################## Log Group #####################
variable "api_gateway_assume_role_arn" {
  description = "If not defined will be created a new role, else will be used this role name"
  type        = string
  default     = null
}

variable "api_gateway_assume_role_id" {
  description = "If not defined will be necessery"
  type        = string
  default     = null
}

variable "api_gateway_assume_role" {
  description = "Assume role to API Gateway"
  type        = any
  default = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "apigateway.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  }
}

variable "api_gateway_assume_role_description" {
  description = "API Gateway assume role description"
  type        = string
  default     = null
}

variable "make_log_group_policy" {
  description = "If true will be created a new log group policy"
  type        = bool
  default     = true
}

variable "log_group_retention_in_days" {
  description = "Log group retention in days to keep the logs in Cloudwatch"
  type        = number
  default     = 7
}

variable "log_group_policy" {
  description = "Log group policy to API Gateway"
  type        = any
  default = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  }
}
