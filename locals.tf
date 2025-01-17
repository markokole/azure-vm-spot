locals {
    domain = "https://prices.azure.com/api/retail/prices"
    arm_region_name = "armRegionName%20eq%20%27${var.location}%27"
    service_name = "serviceName%20eq%20%27Virtual%20Machines%27"
    meter_name = "contains%28meterName%2C+%27Spot%27%29"
    arm_sku_name = "armSkuName%20eq%20%27${var.arm_sku_name}%27"
    product_name = "contains%28productName%2C+%27Windows%27%29%20eq%20false" # false for non Windows VMs

    url = "${local.domain}?skip=0&$filter=${local.arm_region_name}%20and%20${local.service_name}%20and%20${local.meter_name}%20and%20${local.arm_sku_name}%20and%20${local.product_name}"

    items = jsondecode(data.http.get_price.response_body)["Items"]
    
    unit_price = length(local.items) == 1 ? local.items[0]["unitPrice"] : 0
    currency_code = length(local.items) == 1 ? local.items[0]["currencyCode"] : "N/A"
}

