# output location {
#     value = var.location
# }

# output arm_sku_name {
#     value = var.arm_sku_name
# }

# output unit_price {
#     value = local.unit_price
# }

# output currency_code {
#     value = local.currency_code
# }

output spot_price {
    value = local.spot_price["SpotPrice"]
}