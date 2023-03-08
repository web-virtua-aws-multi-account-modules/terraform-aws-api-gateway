locals {
  tags_stage = {
    "Name"     = var.name
    "tf-stage" = var.name
    "tf-ou"    = var.ou_name
  }

  resources_root = flatten([
    for index_resource, resource in var.resources_methods != null ? var.resources_methods : [] : [
      concat(
        [for index_path, path in split("/", resource.path) : {
          index                = index_resource
          index_level          = index_path
          previous_level       = "root"
          method               = resource.method_all_sub_paths == true || path == split("/", resource.path)[length(split("/", resource.path)) - 1]
          method_all_sub_paths = try(resource.method_all_sub_paths, false)
          path_part            = path
          path_array           = compact([for index, value in split("/", resource.path) : index == 0 ? "" : value])
          methods              = resource.methods
          # method #
          http_method               = resource.http_method != null ? resource.http_method : try(var.resources_methods[0].http_method, null)
          authorization_method      = resource.authorization_method != null ? resource.authorization_method : try(var.resources_methods[0].authorization_method, null)
          request_parameters_method = resource.request_parameters_method != null ? resource.request_parameters_method : try(var.resources_methods[0].request_parameters_method, null)
          authorizer_id_external    = resource.authorizer_id_external != null ? resource.authorizer_id_external : try(var.resources_methods[0].authorizer_id_external, null)
          authorizer_id_index       = resource.authorizer_id_index != null ? resource.authorizer_id_index : var.resources_methods[0].authorizer_id_index != null ? var.resources_methods[0].authorizer_id_index : (resource.authorizer_id_external == null && (resource.authorization_method == "COGNITO_USER_POOLS" || resource.authorization_method == "CUSTOM")) ? 0 : null
          # integration
          http_method_integration        = resource.http_method_integration != null ? resource.http_method_integration : try(var.resources_methods[0].http_method_integration, null)
          type_integration               = resource.type_integration != null ? resource.type_integration : try(var.resources_methods[0].type_integration, null)
          uri_integration                = resource.uri_integration != null ? resource.uri_integration : try(var.resources_methods[0].uri_integration, null)
          request_parameters_integration = resource.request_parameters_integration != null ? resource.request_parameters_integration : try(var.resources_methods[0].request_parameters_integration, null)
          # others configurations #
          authorization_scopes_method      = resource.authorization_scopes_method != null ? resource.authorization_scopes_method : try(var.resources_methods[0].authorization_scopes_method, null)
          api_key_required_method          = resource.api_key_required_method != null ? resource.api_key_required_method : try(var.resources_methods[0].api_key_required_method, null)
          operation_name_method            = resource.operation_name_method != null ? resource.operation_name_method : try(var.resources_methods[0].operation_name_method, null)
          request_models_method            = resource.request_models_method != null ? resource.request_models_method : try(var.resources_methods[0].request_models_method, null)
          request_validator_id_method      = resource.request_validator_id_method != null ? resource.request_validator_id_method : try(var.resources_methods[0].request_validator_id_method, null)
          passthrough_behavior_integration = resource.passthrough_behavior_integration != null ? resource.passthrough_behavior_integration : try(var.resources_methods[0].passthrough_behavior_integration, null)
          content_handling_integration     = resource.content_handling_integration != null ? resource.content_handling_integration : try(var.resources_methods[0].content_handling_integration, null)
          connection_type_integration      = resource.connection_type_integration != null ? resource.connection_type_integration : try(var.resources_methods[0].connection_type_integration, null)
          connection_id_integration        = resource.connection_id_integration != null ? resource.connection_id_integration : try(var.resources_methods[0].connection_id_integration, null)
          request_templates_integration    = resource.request_templates_integration != null ? resource.request_templates_integration : try(var.resources_methods[0].request_templates_integration, null)
          credentials_integration          = resource.credentials_integration != null ? resource.credentials_integration : try(var.resources_methods[0].credentials_integration, null)
          cache_key_parameters_integration = resource.cache_key_parameters_integration != null ? resource.cache_key_parameters_integration : try(var.resources_methods[0].cache_key_parameters_integration, null)
          cache_namespace_integration      = resource.cache_namespace_integration != null ? resource.cache_namespace_integration : try(var.resources_methods[0].cache_namespace_integration, null)
          timeout_milliseconds_integration = resource.timeout_milliseconds_integration != null ? resource.timeout_milliseconds_integration : try(var.resources_methods[0].timeout_milliseconds_integration, null)
          tls_config_integration           = resource.tls_config_integration != null ? resource.tls_config_integration : try(var.resources_methods[0].tls_config_integration, null)
          responses                        = resource.responses
          } if index_path == 0
        ]
      )
    ]
  ])

  resource_1 = flatten([
    for index_resource, resource in length(local.resources_root) > 0 ? local.resources_root : [] : [
      concat(
        [for index_path, path in resource.path_array : {
          index_level          = 1
          previous_level       = resource.index
          method               = resource.method_all_sub_paths == true || path == resource.path_array[length(resource.path_array) - 1]
          method_all_sub_paths = try(resource.method_all_sub_paths, false)
          path_part            = path
          path_array           = compact([for index, value in resource.path_array : index == 0 ? "" : value])
          methods              = resource.methods
          # method #
          http_method               = resource.http_method != null ? resource.http_method : try(var.resources_methods[0].http_method, null)
          authorization_method      = resource.authorization_method != null ? resource.authorization_method : try(var.resources_methods[0].authorization_method, null)
          request_parameters_method = resource.request_parameters_method != null ? resource.request_parameters_method : try(var.resources_methods[0].request_parameters_method, null)
          authorizer_id_external    = resource.authorizer_id_external != null ? resource.authorizer_id_external : try(var.resources_methods[0].authorizer_id_external, null)
          authorizer_id_index       = resource.authorizer_id_index != null ? resource.authorizer_id_index : var.resources_methods[0].authorizer_id_index != null ? var.resources_methods[0].authorizer_id_index : (resource.authorizer_id_external == null && (resource.authorization_method == "COGNITO_USER_POOLS" || resource.authorization_method == "CUSTOM")) ? 0 : null
          # integration
          http_method_integration        = resource.http_method_integration != null ? resource.http_method_integration : try(var.resources_methods[0].http_method_integration, null)
          type_integration               = resource.type_integration != null ? resource.type_integration : try(var.resources_methods[0].type_integration, null)
          uri_integration                = resource.uri_integration != null ? resource.uri_integration : try(var.resources_methods[0].uri_integration, null)
          request_parameters_integration = resource.request_parameters_integration != null ? resource.request_parameters_integration : try(var.resources_methods[0].request_parameters_integration, null)
          # others configurations #
          authorization_scopes_method      = resource.authorization_scopes_method != null ? resource.authorization_scopes_method : try(var.resources_methods[0].authorization_scopes_method, null)
          api_key_required_method          = resource.api_key_required_method != null ? resource.api_key_required_method : try(var.resources_methods[0].api_key_required_method, null)
          operation_name_method            = resource.operation_name_method != null ? resource.operation_name_method : try(var.resources_methods[0].operation_name_method, null)
          request_models_method            = resource.request_models_method != null ? resource.request_models_method : try(var.resources_methods[0].request_models_method, null)
          request_validator_id_method      = resource.request_validator_id_method != null ? resource.request_validator_id_method : try(var.resources_methods[0].request_validator_id_method, null)
          passthrough_behavior_integration = resource.passthrough_behavior_integration != null ? resource.passthrough_behavior_integration : try(var.resources_methods[0].passthrough_behavior_integration, null)
          content_handling_integration     = resource.content_handling_integration != null ? resource.content_handling_integration : try(var.resources_methods[0].content_handling_integration, null)
          connection_type_integration      = resource.connection_type_integration != null ? resource.connection_type_integration : try(var.resources_methods[0].connection_type_integration, null)
          connection_id_integration        = resource.connection_id_integration != null ? resource.connection_id_integration : try(var.resources_methods[0].connection_id_integration, null)
          request_templates_integration    = resource.request_templates_integration != null ? resource.request_templates_integration : try(var.resources_methods[0].request_templates_integration, null)
          credentials_integration          = resource.credentials_integration != null ? resource.credentials_integration : try(var.resources_methods[0].credentials_integration, null)
          cache_key_parameters_integration = resource.cache_key_parameters_integration != null ? resource.cache_key_parameters_integration : try(var.resources_methods[0].cache_key_parameters_integration, null)
          cache_namespace_integration      = resource.cache_namespace_integration != null ? resource.cache_namespace_integration : try(var.resources_methods[0].cache_namespace_integration, null)
          timeout_milliseconds_integration = resource.timeout_milliseconds_integration != null ? resource.timeout_milliseconds_integration : try(var.resources_methods[0].timeout_milliseconds_integration, null)
          tls_config_integration           = resource.tls_config_integration != null ? resource.tls_config_integration : try(var.resources_methods[0].tls_config_integration, null)
          responses                        = resource.responses
          } if index_path == 0
        ]
      )
    ]
  ])
  resources_sub_1 = [for index, item in local.resource_1 : merge(item, { index = index })]

  resources_2 = flatten([
    for index_resource, resource in length(local.resources_sub_1) > 0 ? local.resources_sub_1 : [] : [
      concat(
        [for index_path, path in resource.path_array : {
          index_level          = 2
          previous_level       = resource.index
          method               = resource.method_all_sub_paths == true || path == resource.path_array[length(resource.path_array) - 1]
          method_all_sub_paths = try(resource.method_all_sub_paths, false)
          path_part            = path
          path_array           = compact([for index, value in resource.path_array : index == 0 ? "" : value])
          methods              = resource.methods
          # method #
          http_method               = resource.http_method != null ? resource.http_method : try(var.resources_methods[0].http_method, null)
          authorization_method      = resource.authorization_method != null ? resource.authorization_method : try(var.resources_methods[0].authorization_method, null)
          request_parameters_method = resource.request_parameters_method != null ? resource.request_parameters_method : try(var.resources_methods[0].request_parameters_method, null)
          authorizer_id_external    = resource.authorizer_id_external != null ? resource.authorizer_id_external : try(var.resources_methods[0].authorizer_id_external, null)
          authorizer_id_index       = resource.authorizer_id_index != null ? resource.authorizer_id_index : var.resources_methods[0].authorizer_id_index != null ? var.resources_methods[0].authorizer_id_index : (resource.authorizer_id_external == null && (resource.authorization_method == "COGNITO_USER_POOLS" || resource.authorization_method == "CUSTOM")) ? 0 : null
          # integration
          http_method_integration        = resource.http_method_integration != null ? resource.http_method_integration : try(var.resources_methods[0].http_method_integration, null)
          type_integration               = resource.type_integration != null ? resource.type_integration : try(var.resources_methods[0].type_integration, null)
          uri_integration                = resource.uri_integration != null ? resource.uri_integration : try(var.resources_methods[0].uri_integration, null)
          request_parameters_integration = resource.request_parameters_integration != null ? resource.request_parameters_integration : try(var.resources_methods[0].request_parameters_integration, null)
          # others configurations #
          authorization_scopes_method      = resource.authorization_scopes_method != null ? resource.authorization_scopes_method : try(var.resources_methods[0].authorization_scopes_method, null)
          api_key_required_method          = resource.api_key_required_method != null ? resource.api_key_required_method : try(var.resources_methods[0].api_key_required_method, null)
          operation_name_method            = resource.operation_name_method != null ? resource.operation_name_method : try(var.resources_methods[0].operation_name_method, null)
          request_models_method            = resource.request_models_method != null ? resource.request_models_method : try(var.resources_methods[0].request_models_method, null)
          request_validator_id_method      = resource.request_validator_id_method != null ? resource.request_validator_id_method : try(var.resources_methods[0].request_validator_id_method, null)
          passthrough_behavior_integration = resource.passthrough_behavior_integration != null ? resource.passthrough_behavior_integration : try(var.resources_methods[0].passthrough_behavior_integration, null)
          content_handling_integration     = resource.content_handling_integration != null ? resource.content_handling_integration : try(var.resources_methods[0].content_handling_integration, null)
          connection_type_integration      = resource.connection_type_integration != null ? resource.connection_type_integration : try(var.resources_methods[0].connection_type_integration, null)
          connection_id_integration        = resource.connection_id_integration != null ? resource.connection_id_integration : try(var.resources_methods[0].connection_id_integration, null)
          request_templates_integration    = resource.request_templates_integration != null ? resource.request_templates_integration : try(var.resources_methods[0].request_templates_integration, null)
          credentials_integration          = resource.credentials_integration != null ? resource.credentials_integration : try(var.resources_methods[0].credentials_integration, null)
          cache_key_parameters_integration = resource.cache_key_parameters_integration != null ? resource.cache_key_parameters_integration : try(var.resources_methods[0].cache_key_parameters_integration, null)
          cache_namespace_integration      = resource.cache_namespace_integration != null ? resource.cache_namespace_integration : try(var.resources_methods[0].cache_namespace_integration, null)
          timeout_milliseconds_integration = resource.timeout_milliseconds_integration != null ? resource.timeout_milliseconds_integration : try(var.resources_methods[0].timeout_milliseconds_integration, null)
          tls_config_integration           = resource.tls_config_integration != null ? resource.tls_config_integration : try(var.resources_methods[0].tls_config_integration, null)
          responses                        = resource.responses
          } if index_path == 0
        ]
      )
    ]
  ])
  resources_sub_2 = [for index, item in local.resources_2 : merge(item, { index = index })]

  resource_3 = flatten([
    for index_resource, resource in length(local.resources_sub_2) > 0 ? local.resources_sub_2 : [] : [
      concat(
        [for index_path, path in resource.path_array : {
          index_level          = 3
          previous_level       = resource.index
          method               = resource.method_all_sub_paths == true || path == resource.path_array[length(resource.path_array) - 1]
          method_all_sub_paths = try(resource.method_all_sub_paths, false)
          path_part            = path
          path_array           = compact([for index, value in resource.path_array : index == 0 ? "" : value])
          methods              = resource.methods
          # method #
          http_method               = resource.http_method != null ? resource.http_method : try(var.resources_methods[0].http_method, null)
          authorization_method      = resource.authorization_method != null ? resource.authorization_method : try(var.resources_methods[0].authorization_method, null)
          request_parameters_method = resource.request_parameters_method != null ? resource.request_parameters_method : try(var.resources_methods[0].request_parameters_method, null)
          authorizer_id_external    = resource.authorizer_id_external != null ? resource.authorizer_id_external : try(var.resources_methods[0].authorizer_id_external, null)
          authorizer_id_index       = resource.authorizer_id_index != null ? resource.authorizer_id_index : var.resources_methods[0].authorizer_id_index != null ? var.resources_methods[0].authorizer_id_index : (resource.authorizer_id_external == null && (resource.authorization_method == "COGNITO_USER_POOLS" || resource.authorization_method == "CUSTOM")) ? 0 : null
          # integration
          http_method_integration        = resource.http_method_integration != null ? resource.http_method_integration : try(var.resources_methods[0].http_method_integration, null)
          type_integration               = resource.type_integration != null ? resource.type_integration : try(var.resources_methods[0].type_integration, null)
          uri_integration                = resource.uri_integration != null ? resource.uri_integration : try(var.resources_methods[0].uri_integration, null)
          request_parameters_integration = resource.request_parameters_integration != null ? resource.request_parameters_integration : try(var.resources_methods[0].request_parameters_integration, null)
          # others configurations #
          authorization_scopes_method      = resource.authorization_scopes_method != null ? resource.authorization_scopes_method : try(var.resources_methods[0].authorization_scopes_method, null)
          api_key_required_method          = resource.api_key_required_method != null ? resource.api_key_required_method : try(var.resources_methods[0].api_key_required_method, null)
          operation_name_method            = resource.operation_name_method != null ? resource.operation_name_method : try(var.resources_methods[0].operation_name_method, null)
          request_models_method            = resource.request_models_method != null ? resource.request_models_method : try(var.resources_methods[0].request_models_method, null)
          request_validator_id_method      = resource.request_validator_id_method != null ? resource.request_validator_id_method : try(var.resources_methods[0].request_validator_id_method, null)
          passthrough_behavior_integration = resource.passthrough_behavior_integration != null ? resource.passthrough_behavior_integration : try(var.resources_methods[0].passthrough_behavior_integration, null)
          content_handling_integration     = resource.content_handling_integration != null ? resource.content_handling_integration : try(var.resources_methods[0].content_handling_integration, null)
          connection_type_integration      = resource.connection_type_integration != null ? resource.connection_type_integration : try(var.resources_methods[0].connection_type_integration, null)
          connection_id_integration        = resource.connection_id_integration != null ? resource.connection_id_integration : try(var.resources_methods[0].connection_id_integration, null)
          request_templates_integration    = resource.request_templates_integration != null ? resource.request_templates_integration : try(var.resources_methods[0].request_templates_integration, null)
          credentials_integration          = resource.credentials_integration != null ? resource.credentials_integration : try(var.resources_methods[0].credentials_integration, null)
          cache_key_parameters_integration = resource.cache_key_parameters_integration != null ? resource.cache_key_parameters_integration : try(var.resources_methods[0].cache_key_parameters_integration, null)
          cache_namespace_integration      = resource.cache_namespace_integration != null ? resource.cache_namespace_integration : try(var.resources_methods[0].cache_namespace_integration, null)
          timeout_milliseconds_integration = resource.timeout_milliseconds_integration != null ? resource.timeout_milliseconds_integration : try(var.resources_methods[0].timeout_milliseconds_integration, null)
          tls_config_integration           = resource.tls_config_integration != null ? resource.tls_config_integration : try(var.resources_methods[0].tls_config_integration, null)
          responses                        = resource.responses
          } if index_path == 0
        ]
      )
    ]
  ])
  resources_sub_3 = [for index, item in local.resource_3 : merge(item, { index = index })]

  resource_4 = flatten([
    for index_resource, resource in length(local.resources_sub_3) > 0 ? local.resources_sub_3 : [] : [
      concat(
        [for index_path, path in resource.path_array : {
          index_level          = 4
          previous_level       = resource.index
          method               = resource.method_all_sub_paths == true || path == resource.path_array[length(resource.path_array) - 1]
          method_all_sub_paths = try(resource.method_all_sub_paths, false)
          path_part            = path
          path_array           = compact([for index, value in resource.path_array : index == 0 ? "" : value])
          methods              = resource.methods
          # method #
          http_method               = resource.http_method != null ? resource.http_method : try(var.resources_methods[0].http_method, null)
          authorization_method      = resource.authorization_method != null ? resource.authorization_method : try(var.resources_methods[0].authorization_method, null)
          request_parameters_method = resource.request_parameters_method != null ? resource.request_parameters_method : try(var.resources_methods[0].request_parameters_method, null)
          authorizer_id_external    = resource.authorizer_id_external != null ? resource.authorizer_id_external : try(var.resources_methods[0].authorizer_id_external, null)
          authorizer_id_index       = resource.authorizer_id_index != null ? resource.authorizer_id_index : var.resources_methods[0].authorizer_id_index != null ? var.resources_methods[0].authorizer_id_index : (resource.authorizer_id_external == null && (resource.authorization_method == "COGNITO_USER_POOLS" || resource.authorization_method == "CUSTOM")) ? 0 : null
          # integration
          http_method_integration        = resource.http_method_integration != null ? resource.http_method_integration : try(var.resources_methods[0].http_method_integration, null)
          type_integration               = resource.type_integration != null ? resource.type_integration : try(var.resources_methods[0].type_integration, null)
          uri_integration                = resource.uri_integration != null ? resource.uri_integration : try(var.resources_methods[0].uri_integration, null)
          request_parameters_integration = resource.request_parameters_integration != null ? resource.request_parameters_integration : try(var.resources_methods[0].request_parameters_integration, null)
          # others configurations #
          authorization_scopes_method      = resource.authorization_scopes_method != null ? resource.authorization_scopes_method : try(var.resources_methods[0].authorization_scopes_method, null)
          api_key_required_method          = resource.api_key_required_method != null ? resource.api_key_required_method : try(var.resources_methods[0].api_key_required_method, null)
          operation_name_method            = resource.operation_name_method != null ? resource.operation_name_method : try(var.resources_methods[0].operation_name_method, null)
          request_models_method            = resource.request_models_method != null ? resource.request_models_method : try(var.resources_methods[0].request_models_method, null)
          request_validator_id_method      = resource.request_validator_id_method != null ? resource.request_validator_id_method : try(var.resources_methods[0].request_validator_id_method, null)
          passthrough_behavior_integration = resource.passthrough_behavior_integration != null ? resource.passthrough_behavior_integration : try(var.resources_methods[0].passthrough_behavior_integration, null)
          content_handling_integration     = resource.content_handling_integration != null ? resource.content_handling_integration : try(var.resources_methods[0].content_handling_integration, null)
          connection_type_integration      = resource.connection_type_integration != null ? resource.connection_type_integration : try(var.resources_methods[0].connection_type_integration, null)
          connection_id_integration        = resource.connection_id_integration != null ? resource.connection_id_integration : try(var.resources_methods[0].connection_id_integration, null)
          request_templates_integration    = resource.request_templates_integration != null ? resource.request_templates_integration : try(var.resources_methods[0].request_templates_integration, null)
          credentials_integration          = resource.credentials_integration != null ? resource.credentials_integration : try(var.resources_methods[0].credentials_integration, null)
          cache_key_parameters_integration = resource.cache_key_parameters_integration != null ? resource.cache_key_parameters_integration : try(var.resources_methods[0].cache_key_parameters_integration, null)
          cache_namespace_integration      = resource.cache_namespace_integration != null ? resource.cache_namespace_integration : try(var.resources_methods[0].cache_namespace_integration, null)
          timeout_milliseconds_integration = resource.timeout_milliseconds_integration != null ? resource.timeout_milliseconds_integration : try(var.resources_methods[0].timeout_milliseconds_integration, null)
          tls_config_integration           = resource.tls_config_integration != null ? resource.tls_config_integration : try(var.resources_methods[0].tls_config_integration, null)
          responses                        = resource.responses
          } if index_path == 0
        ]
      )
    ]
  ])
  resources_sub_4 = [for index, item in local.resource_4 : merge(item, { index = index })]

  join_resources    = concat(local.resources_root, local.resources_sub_1, local.resources_sub_2, local.resources_sub_3, local.resources_sub_4)
  resources_indexed = [for index, item in local.join_resources : merge(item, { index_resource = index })]

  methods_generate = flatten([
    for index, resource in local.resources_indexed : [resource.methods != null ? [
      for item in resource.methods : merge(resource, {
        http_method                      = item.http_method != null ? item.http_method : try(item[0].http_method, null)
        http_method_integration          = item.http_method_integration != null ? item.http_method_integration : try(item[0].http_method_integration, null)
        type_integration                 = item.type_integration != null ? item.type_integration : try(item[0].type_integration, null)
        uri_integration                  = item.uri_integration != null ? item.uri_integration : try(item[0].uri_integration, null)
        request_parameters_integration   = item.request_parameters_integration != null ? item.request_parameters_integration : try(item[0].request_parameters_integration, null)
        passthrough_behavior_integration = item.passthrough_behavior_integration != null ? item.passthrough_behavior_integration : try(item[0].passthrough_behavior_integration, null)
        content_handling_integration     = item.content_handling_integration != null ? item.content_handling_integration : try(item[0].content_handling_integration, null)
        connection_type_integration      = item.connection_type_integration != null ? item.connection_type_integration : try(item[0].connection_type_integration, null)
        connection_id_integration        = item.connection_id_integration != null ? item.connection_id_integration : try(item[0].connection_id_integration, null)
        request_templates_integration    = item.request_templates_integration != null ? item.request_templates_integration : try(item[0].request_templates_integration, null)
        credentials_integration          = item.credentials_integration != null ? item.credentials_integration : try(item[0].credentials_integration, null)
        cache_key_parameters_integration = item.cache_key_parameters_integration != null ? item.cache_key_parameters_integration : try(item[0].cache_key_parameters_integration, null)
        cache_namespace_integration      = item.cache_namespace_integration != null ? item.cache_namespace_integration : try(item[0].cache_namespace_integration, null)
        timeout_milliseconds_integration = item.timeout_milliseconds_integration != null ? item.timeout_milliseconds_integration : try(item[0].timeout_milliseconds_integration, null)
        tls_config_integration           = item.tls_config_integration != null ? item.tls_config_integration : try(item[0].tls_config_integration, null)
      })] : [
      merge(resource, {})]
    ]
  ])
  methods_no_indexed = [for index, item in local.methods_generate : item if item.method]
  methods            = [for index, item in local.methods_no_indexed : merge(item, { index_method = index })]

  method_responses = flatten([
    for index, method in local.methods : [method.responses != null ? [
      for item in method.responses.methods != null ? method.responses.methods : [] : merge(method, {
        method_response = {
          status_code         = item.status_code
          response_models     = item.response_models
          response_parameters = item.response_parameters
        }
      })] : []
    ]
  ])

  integration_responses = flatten([
    for index, method in local.methods : [method.responses != null ? [
      for item in method.responses.integrations != null ? method.responses.integrations : [] : merge(method, {
        integration_response = {
          status_code         = item.status_code
          selection_pattern   = item.selection_pattern
          response_templates  = item.response_templates
          content_handling    = item.content_handling
          response_parameters = item.response_parameters
        }
      })] : []
    ]
  ])
}

locals {
  api_keys = flatten([
    for index, plan in var.use_plans_api_keys != null ? var.use_plans_api_keys : [] : [
      for key in plan.keys != null ? plan.keys : [] : merge(plan, {
        index = index
        key   = key
      })
    ]
  ])
}
