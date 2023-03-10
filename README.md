# AWS API Gateway for multiples accounts and regions with Terraform module
* This module simplifies creating and configuring of a API Gateway across multiple accounts and regions on AWS

* Is possible use this module with one region using the standard profile or multi account and regions using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Create file versions.tf with the exemple code below:
```hcl
terraform {
  required_version = ">= 1.1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
```

* Criate file provider.tf with the exemple code below:
```hcl
provider "aws" {
  alias   = "alias_profile_a"
  region  = "us-east-1"
  profile = "my-profile"
}

provider "aws" {
  alias   = "alias_profile_b"
  region  = "us-east-2"
  profile = "my-profile"
}
```


## Features enable of API Gateway configurations for this module:

- API Gateway rest api
- VPC endpoint
- API Gateway resource
- API Gateway method
- API Gateway method response
- API Gateway integration
- API Gateway integration response
- Lambda permission
- API Gateway deployment
- API Gateway stage
- API Gateway authorizer
- API Gateway method settings
- API Gateway usage plan
- API Gateway api key
- API Gateway usage plan key
- ACM certificate
- Records sets domain validation
- ACM certificate validation
- Records sets
- IAM role
- IAM role policy
- API Gateway account
- Cloudwatch log group

## Usage exemples
* OBS: This module is able to create resources from 1 up to 5 levels of the paths, exemple max: item1/item2/item3/item5/item5

### API Gateway without security and with lambda proxy of type AWS_PROXY allowing all paths from the /

```hcl
module "api_lambda" {
  source = "web-virtua-aws-multi-account-modules/api-gateway/aws"

  name                 = "tf-api-gateway-lambda"
  stage_name           = "v1"
  lambda_function_name = var.lambda_function_name
  description          = "Proxy to handle requests to lambda invoke ARN"
  make_deployment      = true

  method_settings = {
    logging_level = "INFO"
  }

  resources_methods = [
    {
      path        = "{proxy+}"
      http_method = "ANY"
      request_parameters_method = {
        "method.request.path.proxy" = true
      }
      authorization_method    = "NONE"
      http_method_integration = "POST"
      type_integration        = "AWS_PROXY"
      uri_integration         = var.lambda_function_invoke_arn
    },
  ]

  hosted_zone_id   = "Z0820...RQYIK"
  hosted_zone_name = "sls.domain.me"
  master_domain    = "api.lambda.sls.domain.me"
  alternatives_domains = [
    "www.api.lambda.sls.domain.me"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### API Gateway with authorizer to security using cognito and with lambda proxy of type AWS_PROXY allowing all paths from the /

```hcl
module "api_lambda" {
  source = "web-virtua-aws-multi-account-modules/api-gateway/aws"

  name                 = "tf-api-gateway-lambda"
  stage_name           = "v1"
  lambda_function_name = var.lambda_function_name
  description          = "Proxy to handle requests to lambda invoke ARN"

  method_settings = {
    logging_level = "INFO"
  }

  resources_methods = [
    {
      path        = "{proxy+}"
      http_method = "ANY"
      request_parameters_method = {
        "method.request.path.proxy" = true
      }
      authorization_method    = "COGNITO_USER_POOLS"
      http_method_integration = "POST"
      type_integration        = "AWS_PROXY"
      uri_integration         = var.lambda_function_invoke_arn
    },
  ]

  api_gateway_authorizers = [
    {
      name          = "tf-cognito-user-pool-1"
      type          = "COGNITO_USER_POOLS"
      provider_arns = [var.cognito_user_pool_arn]
    }
  ]

  hosted_zone_id   = "Z0820...RQYIK"
  hosted_zone_name = "sls.domain.me"
  master_domain    = "api.lambda.sls.domain.me"
  alternatives_domains = [
    "www.api.lambda.sls.domain.me"
  ]

  providers = {
    aws = aws.alias_profile_a
  }
}
```

### API Gateway HTTP with authorizer to security using cognito for all resources, with lambda proxy of type HTTP_PROXY
* In this configuration all resources will receive the configuration setup on the first element of the resources_methods variable, if you set other configuration to any resource It's will be used else the first element configuration will be efectived.

```hcl
module "api_http" {
  source = "web-virtua-aws-multi-account-modules/api-gateway/aws"

  name                    = "tf-api-gateway-http"
  lambda_function_name    = var.lambda_function.name
  stage_name              = "v1"
  make_deployment         = true
  make_lambda_permissions = false
  description             = "Proxy to handle requests to our API"

  method_settings = {
    logging_level = "INFO"
  }

  resources_methods = [
    {
      path                    = "c1/c2/c3"
      http_method             = "ANY"
      authorization_method    = "COGNITO_USER_POOLS"
      http_method_integration = "ANY"
      type_integration        = "HTTP_PROXY"
      uri_integration         = "https://cpwszi...dvhy.lambda-url.us-east-1.on.aws/{proxy}"
      request_parameters_method = {
        "method.request.path.proxy" = true
      }
      request_parameters_integration = {
        "integration.request.path.proxy" = "method.request.path.proxy"
      }
    },
    {
      path = "b1/{proxy+}"
    },
    {
      path = "a1"
    },
    {
      path = "resource/{proxy+}"
    },
    {
      path = "e1/e2/e3/e4/e5"
    },
    {
      path = "d1/d2/d3/d4"
    },
    {
      path = "item"
    },
  ]

  api_gateway_authorizers = [
    {
      name          = "tf-cognito-user-pool-1"
      type          = "COGNITO_USER_POOLS"
      provider_arns = [var.cognito_user_pool_arn]
    }
  ]

  hosted_zone_id   = "Z0820...QYIK"
  hosted_zone_name = "sls.domain.me"
  master_domain    = "api.sls.domain.me"
  alternatives_domains = [
    "www.api.sls.domain.me"
  ]

  providers = {
    aws = aws.alias_profile_a
  }
}
```

### API Gateway HTTP with many configurations of resources, with and without authorizer to security using cognito, with lambda proxy of type HTTP_PROXY and use plans 

```hcl
module "api_http" {
  source = "web-virtua-aws-multi-account-modules/api-gateway/aws"

  name                    = "tf-api-gateway-http"
  lambda_function_name    = var.lambda_function_name
  stage_name              = "v1"
  make_deployment         = true
  make_lambda_permissions = false
  description             = "Proxy to handle requests to our API"

  method_settings = {
    logging_level = "INFO"
  }

  resources_methods = [
    {
      path        = "c1/c2/c3"
      http_method = "ANY"
      methods = [
        {
          http_method             = "GET"
          http_method_integration = "GET"
          type_integration        = "HTTP_PROXY"
          uri_integration         = "https://cpwszi...dvhy.lambda-url.us-east-1.on.aws/{proxy}"
          request_parameters_integration = {
            "integration.request.path.proxy" = "method.request.path.proxy"
          }
        },
        {
          http_method             = "OPTIONS"
          http_method_integration = "OPTIONS"
          type_integration        = "HTTP_PROXY"
          uri_integration         = "https://cpwszi...dvhy.lambda-url.us-east-1.on.aws/{proxy}"
          request_parameters_integration = {
            "integration.request.path.proxy" = "method.request.path.proxy"
          }
        }
      ]
      authorization_method = "NONE"
      method_all_sub_paths = true
      request_parameters_method = {
        "method.request.path.proxy" = true
      }
      http_method_integration = "ANY"
      type_integration        = "HTTP_PROXY"
      uri_integration         = "https://cpwszi...dvhy.lambda-url.us-east-1.on.aws/{proxy}"
      request_parameters_integration = {
        "integration.request.path.proxy" = "method.request.path.proxy"
      }
    },
    {
      path                 = "b1/{proxy+}"
      authorization_method = "COGNITO_USER_POOLS"
    },
    {
      path                    = "a1"
      http_method             = "ANY"
      http_method_integration = "ANY"
      responses = {
        methods = [
          {
            status_code = "200"
          },
          {
            status_code = "201"
          },
          {
            status_code = "202"
          }
        ]
        integrations = [
          {
            status_code = "200"
            response_templates = {
              "application/json" = jsonencode({
                body = "Hello from the movies API!"
              })
            }
          },
          {
            status_code       = "201"
            selection_pattern = "5\\d{2}"
          }
        ]
      }
    },
    {
      path                    = "resource/{proxy+}"
      http_method_integration = "ANY"
    },
    {
      path                 = "e1/e2/e3/e4/e5"
      http_method          = "POST"
      authorization_method = "NONE"
      request_parameters_method = {
        "method.request.path.proxy" = true
      }
      authorization_method = "COGNITO_USER_POOLS"
    },
    {
      path                    = "d1/d2/d3/d4"
      http_method_integration = "PATCH"
    },
    {
      path                    = "mock"
      http_method             = "ANY"
      http_method_integration = "ANY"
      type_integration        = "HTTP_PROXY"
      responses = {
        methods = [
          {
            status_code = "200"
          },
          {
            status_code = "201"
          }
        ]
        integrations = [
          {
            status_code = "200"
            response_templates = {
              "application/json" = jsonencode({
                body = "Hello from the movies API!"
              })
            }
          },
          {
            status_code       = "201"
            selection_pattern = "5\\d{2}"
          }
        ]
      }
    },
  ]

  use_plans_api_keys = [
    {
      name         = "tf-100-requests-week"
      quota_limit  = 100
      quota_period = "WEEK"
      description  = "Allow use to 100 requests per week"
      keys = [
        {
          name = "tf-api-week"
        },
        {
          name = "tf-api-second"
        }
      ]
    },
    {
      name         = "tf-200-requests-week"
      quota_limit  = 200
      quota_period = "WEEK"
      description  = "Allow use to 200 requests per week"
      keys = [
        {
          name = "tf-api-test"
        }
      ]
    }
  ]

  api_gateway_authorizers = [
    {
      name          = "tf-cognito-user-pool-1"
      type          = "COGNITO_USER_POOLS"
      provider_arns = [var.cognito_user_pool_arn]
    }
  ]

  hosted_zone_id   = "Z0820...QYIK"
  hosted_zone_name = "sls.domain.me"
  master_domain    = "api.sls.domain.me"
  alternatives_domains = [
    "www.api.sls.domain.me"
  ]

  providers = {
    aws = aws.alias_profile_a
  }
}
```

## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| name | `string` | `-` | yes | VPC Cidr Block | `-` |
| region | `string` | `us-east-1` | no | API Gateway name | `-` |
| lambda_function_name | `string` | `null` | no | Lambda function name to be access for API Gateway | `-` |
| stage_name | `string` | `null` | no | Stage name to API Gateway deployment, ex: v1, v2... | `-` |
| deployment_stage_name | `string` | `null` | no | Deployment stage name to API Gateway deployment | `-` |
| deployment_stage_description | `string` | `null` | no | Deployment stage description to API Gateway deployment | `-` |
| deployment_description | `string` | `null` | no | Deployment description to API Gateway deployment | `-` |
| deployment_variables | `map(any)` | `{}` | no | Deployment variables to API Gateway deployment | `-` |
| description | `string` | `API Gateway` | no | API Gateway description | `-` |
| vpc_id | `string` | `null` | no | VPC ID | `-` |
| subnet_ids | `list(string)` | `null` | no | Subnet ID's | `-` |
| security_group_ids | `list(string)` | `null` | no | Security groups ids | `-` |
| vpc_endpoint_quantity_create | `number` | `0` | no | Quantity of the new vpc endpoint to create | `-` |
| api_vpc_endpoint_ids | `list(string)` | `null` | no | If defined will be used in a API rest | `-` |
| private_dns_enabled | `bool` | `false` | no | Private DNS enabled | `*`false <br> `*`true |
| vpc_endpoint_type | `string` | `Interface` | no | VPC endpoint type | `-` |
| vpc_service_name | `string` | `null` | no | VPC service name | `-` |
| endpoint_configuration_types | `list(string)` | `["REGIONAL"]` | no | Endpoint configuration types | `-` |
| ou_name | `string` | `no` | no | Organization unit name | `-` |
| use_tags_default | `bool` | `true` | no | If true will be use the tags | `*`false <br> `*`true 
| tags | `map(any)` | `{}` | no | Tags to resources | `-` |
| tags_domain_names | `map(any)` | `{}` | no | Tags to api gateway domain names | `-` |
| tags_iam_role | `map(any)` | `{}` | no | Tags to IAM role | `-` |
| tags_log_gruup | `map(any)` | `{}` | no | Tags to Cloudwatch log group | `-` |
| tags_stage | `map(any)` | `{}` | no | Tags to stage | `-` |
| tags_use_plans | `map(any)` | `{}` | no | Tags to use plans | `-` |
| tags_api_keys | `map(any)` | `{}` | no | Tags to API Keys | `-` |
| stage_extra_settings | `object` | `null` | no | Stage extra settings to API Gateway deployment | `-` |
| api_gateway_authorizers | `object` | `null` | no | List of Cognito API Gateway authorizers | `-` |
| resources_methods | `object` | `null` | no | List of resources that represent the path configurations to enpoints | `-` |
| lambda_permission_api | `object` | `object` | no | List with lambda functions that give allow access to API Gateway | `-` |
| method_settings | `object` | `null` | no | Method settings to configuration logs | `-` |
| use_plans_api_keys | `object` | `null` | no | List with all the use plans and API keys to be used in API Gateway | `-` |
| hosted_zone_id | `string` | `null` | no | Route 53 hosted zone ID domain, ex: Z0820...QYIK | `-` |
| hosted_zone_name | `string` | `null` | no | Route 53 hosted zone name domain, ex: exemple.com | `-` |
| master_domain | `string` | `null` | no | Master domain that received request and redirect to API Gateway, ex: test.exemple.com | `-` |
| alternatives_domains | `list(string)` | `null` | no | Alternatives domais that will be redirec to same API Gateway | `-` |
| endpoint_configuration_type | `list(string)` | `["REGIONAL"]` | no | Endpoint configuration type to API Gateway domain name, can be EDGE or REGIONAL | `*`REGIONAL <br> `*`EDGEs |
| security_policy | `string` | `null` | no | Transport Layer Security (TLS) version + cipher suite for this DomainName, can be TLS_1_0 or TLS_1_2 | `*`TLS_1_0 <br> `*`TLS_1_2 |
| make_acm_certificate | `bool` | `true` | no | If true will be created the ACM and fqdn records | `*`false <br> `*`true |
| make_records | `bool` | `true` | no | If true will be created the records redirecting to API Gateway, is make_acm_certificate variable is required in this configuration | `*`false <br> `*`true |
| make_deployment | `bool` | `true` | no | If true will be created a deployment and resources associates | `*`false <br> `*`true |
| make_lambda_permissions | `bool` | `true` | no | If true will be created a lambda permissions to API Gateway | `*`false <br> `*`true |
| domain_path_mapping_new_version | `object` | `null` | no | This variable define a new version in the custom domains, using the same DNS, but mapping to a new API Gateway, ex: exemple.com/v2, if used the make_acm_certificate variables should be set as true | `-` |
| api_gateway_assume_role_arn | `string` | `null` | no | If not defined will be created a new role, else will be used this role ARN, but will be required also defined the api_gateway_assume_role_id variable | `-` |
| api_gateway_assume_role_id | `string` | `null` | no | If api_gateway_assume_role_arn variable is defined, then this variable will be necessery as well | `-` |
| api_gateway_assume_role | `any` | `object` | no | Assume role to API Gateway | `-` |
| api_gateway_assume_role_description | `string` | `null` | no | API Gateway assume role description | `-` |
| make_log_group_policy | `bool` | `true` | no | If true will be created a new log group policy | `*`false <br> `*`true |
| log_group_retention_in_days | `number` | `7` | no | Log group retention in days to keep the logs in Cloudwatch | `-` |
| log_group_policy | `any` | `object` | no | Log group policy to API Gateway | `-` |

* Model of variable stage_extra_settings
```hcl
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
```

* Model of variable api_gateway_authorizers
```hcl
variable "api_gateway_authorizers" {
  description = "List of Cognito API Gateway authorizers"
  type = list(object({
    name                             = string
    provider_arns                    = optional(list(string))
    type                             = optional(string)
    authorizer_uri                   = optional(string)
    identity_source                  = optional(string)
    authorizer_credentials           = optional(string)
    identity_validation_expression   = optional(string)
    authorizer_result_ttl_in_seconds = optional(number)
  }))
  default = [
    {
      name          = "tf-cognito-user-pool-1"
      type          = "COGNITO_USER_POOLS"
      provider_arns = [var.cognito_user_pool_arn]
    }
  ]
}
```

* Model of variable resources_methods
```hcl
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
  default = [
    {
      path                    = "{proxy+}"
      http_method             = "ANY"
      authorization_method    = "NONE"
      authorization_method    = "COGNITO_USER_POOLS"
      http_method_integration = "POST"
      type_integration        = "AWS_PROXY"
      uri_integration         = var.lambda_function_invoke_arn
      request_parameters_method = {
        "method.request.path.proxy" = true
      }
    },
  ]
}
```

* Model of variable lambda_permission_api
```hcl
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
```

* Model of variable method_settings
```hcl
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
  default = {
    logging_level = "INFO"
  }
}
```

* Model of variable use_plans_api_keys
```hcl
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
  default = [
    {
      name         = "tf-100-requests-week"
      quota_limit  = 100
      quota_period = "WEEK"
      description  = "Allow use to 100 requests per week"
      keys = [
        {
          name = "tf-api-week"
        },
        {
          name = "tf-api-second"
        }
      ]
    },
    {
      name         = "tf-200-requests-week"
      quota_limit  = 200
      quota_period = "WEEK"
      description  = "Allow use to 200 requests per week"
      keys = [
        {
          name = "tf-api-test"
        }
      ]
    }
  ]
}
```


## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.create_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_api_gateway_rest_api.create_gateway_rest_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_resource.create_resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_method.create_methods](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.create_method_responses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_integration.create_integrations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.create_method_integration_responses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_lambda_permission.create_lambda_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_api_gateway_deployment.create_api_gateway_deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_stage.create_api_gateway_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_authorizer.api_gateway_authorizers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_authorizer) | resource |
| [aws_api_gateway_method_settings.create_method_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_usage_plan.create_usage_plans](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan) | resource |
| [aws_api_gateway_api_key.create_api_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key) | resource |
| [aws_api_gateway_usage_plan_key.create_attach_api_key_usage_plan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan_key) | resource |
| [aws_iam_role.create_iam_role_api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_api_gateway_account.create_api_gateway_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_iam_role_policy.create_log_group_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_cloudwatch_log_group.create_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_api_gateway_domain_name.create_domain_names](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_api_gateway_base_path_mapping.create_domain_path_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_base_path_mapping.create_domain_path_mapping_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [module.create_acm_certificate](https://registry.terraform.io/modules/web-virtua-aws-multi-account-modules/acm/aws/latest) | resource |
| [module.create_records](https://registry.terraform.io/modules/web-virtua-aws-multi-account-modules/route53/aws/latest) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_endpoints` | VPC endpoints |
| `vpc_endpoints_ids` | VPC endpoint IDs |
| `vpc_endpoints_arns` | VPC endpoint ARNs |
| `gateway_rest_api` | Gateway rest API |
| `gateway_rest_api_id` | Gateway rest API ID |
| `gateway_rest_api_arn` | Gateway rest API ARN |
| `gateway_rest_api_execution_arn` | Gateway rest API execution ARN |
| `gateway_rest_api_root_resource_id` | Gateway rest API root resource ID |
| `gateway_rest_api_endpoint_configuration` | Gateway rest API endpoint configuration |
| `resources` | Resources of API Gateway |
| `methods` | Methods of API Gateway |
| `methods_reponses` | Methods responses of API Gateway |
| `integrations` | Integration of API Gateway |
| `integrations_reponses` | Integration responses of API Gateway |
| `lambda_permissions` | Lambda permissions of API Gateway |
| `api_gateway_deployment` | API Gateway deployment of API Gateway |
| `api_gateway_deployment_id` | API Gateway deployment ID of API Gateway |
| `api_gateway_deployment_invoke_url` | API Gateway deployment invoke URL of API Gateway |
| `api_gateway_deployment_execution_arn` | API Gateway deployment execution ARN of API Gateway |
| `api_gateway_stage` | API Gateway stage of API Gateway |
| `api_gateway_stage_id` | API Gateway stage ID of API Gateway |
| `api_gateway_stage_arn` | API Gateway stage ARN of API Gateway |
| `api_gateway_stage_invoke_url` | API Gateway stage invoke URL of API Gateway |
| `api_gateway_authorizers` | API Gateway authorizers |
| `api_gateway_authorizers_ids` | API Gateway authorizers IDs |
| `api_gateway_authorizers_arns` | API Gateway authorizers ARNs |
| `method_settings` | API Gateway method settings |
| `usage_plans` | API Gateway usage plans |
| `api_keys` | API Gateway API keys |
| `acm_certificate_arn` | ACM certificate ARN |
| `acm_certificate_domain_validation_options` | ACM certificate domain validation options |
| `records_domain_validation` | Records domain validation |
| `acm_certificate_validation` | ACM certificate validation |
| `fqdn_records` | List fqdn records |
| `iam_role_api_gateway` | IAM role log group to API Gateway |
| `iam_role_api_gateway_id` | IAM role log group ID to API Gateway |
| `iam_role_api_gateway_arn` | IAM role log group ARN to API Gateway |
| `api_gateway_account` | API Gateway account |
| `log_group_policy` | Log group policy |
| `cloudwatch_log_group` | Cloudwatch log group |
