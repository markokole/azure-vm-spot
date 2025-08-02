output spot_price {
    value = lookup(local.data, "Data", "N/A") == "N/A" ? local.arm_sku_error_message : local.data["Data"]
}

output spots_with_price {
    value = length(local.instances) != 0 ? local.instances : local.region_error_message
}