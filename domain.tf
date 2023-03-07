locals {
  domains = var.master_domain != null ? concat([var.master_domain], var.alternatives_domains != null ? var.alternatives_domains : []) : []

  tags_domain_names = {
    "Name"           = "${var.name}-domain-name"
    "tf-domain-name" = "${var.name}-domain-name"
    "tf-ou"          = "${var.name}-domain-name"
  }
}

module "create_acm_certificate" {
  count = var.make_acm_certificate ? 1 : 0

  source  = "web-virtua-aws-multi-account-modules/acm/aws"
  version = ">=1.0.0"

  zone_id_route53      = var.hosted_zone_id
  name_prefix          = "${replace(var.master_domain, ".", "-")}-acm"
  master_domain        = var.master_domain
  alternatives_domains = var.alternatives_domains

  depends_on = [

  ]
}

resource "aws_api_gateway_domain_name" "create_domain_names" {
  count = var.make_acm_certificate ? length(local.domains) : 0

  domain_name              = local.domains[count.index]
  regional_certificate_arn = module.create_acm_certificate[0].acm_certificate_arn
  security_policy          = var.security_policy

  endpoint_configuration {
    types = var.endpoint_configuration_type
  }

  tags = merge(var.tags_domain_names, var.use_tags_default ? local.tags_domain_names : {})

  depends_on = [
    module.create_acm_certificate
  ]
}

module "create_records" {
  count = (var.make_acm_certificate && var.make_records) ? length(aws_api_gateway_domain_name.create_domain_names) : 0

  source  = "web-virtua-aws-multi-account-modules/route53/aws"
  version = ">=1.0.1"

  records = [
    {
      name    = substr(replace(aws_api_gateway_domain_name.create_domain_names[count.index].domain_name, var.hosted_zone_name, ""), 0, length(replace(aws_api_gateway_domain_name.create_domain_names[count.index].domain_name, var.hosted_zone_name, "")) - 1)
      type    = "A"
      zone_id = var.hosted_zone_id
      alias = {
        name                   = aws_api_gateway_domain_name.create_domain_names[count.index].regional_domain_name
        zone_id                = aws_api_gateway_domain_name.create_domain_names[count.index].regional_zone_id
        evaluate_target_health = true
      }
    },
  ]

  depends_on = [
    aws_api_gateway_domain_name.create_domain_names
  ]
}

resource "aws_api_gateway_base_path_mapping" "create_domain_path_mapping" {
  count = (var.make_acm_certificate && var.make_deployment && var.resources_methods != null) ? length(aws_api_gateway_domain_name.create_domain_names) : 0

  api_id      = aws_api_gateway_rest_api.create_gateway_rest_api.id
  stage_name  = aws_api_gateway_stage.create_api_gateway_stage[0].stage_name
  domain_name = aws_api_gateway_domain_name.create_domain_names[count.index].domain_name
  base_path   = null

  depends_on = [
    aws_api_gateway_rest_api.create_gateway_rest_api,
    aws_api_gateway_stage.create_api_gateway_stage,
    aws_api_gateway_domain_name.create_domain_names
  ]
}

# Version 2 only can create this part using the same domain but appointment to a new API Gateway
resource "aws_api_gateway_base_path_mapping" "create_domain_path_mapping_version" {
  count = (var.domain_path_mapping_new_version != null && var.make_deployment && var.resources_methods != null) ? length(var.domain_path_mapping_new_version.domain_names) : 0

  api_id      = aws_api_gateway_rest_api.create_gateway_rest_api.id
  stage_name  = aws_api_gateway_stage.create_api_gateway_stage[0].stage_name
  domain_name = var.domain_path_mapping_new_version.domain_names[count.index]
  base_path   = var.domain_path_mapping_new_version.base_path

  depends_on = [
    aws_api_gateway_rest_api.create_gateway_rest_api,
    aws_api_gateway_stage.create_api_gateway_stage
  ]
}
