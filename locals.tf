locals {
    domain = "https://prices.azure.com/api/retail/prices"
    arm_region_name = "armRegionName%20eq%20%27${var.region}%27"
    service_name = "serviceName%20eq%20%27Virtual%20Machines%27"
    meter_name = "contains%28meterName%2C+%27Spot%27%29"
    arm_sku_name = "armSkuName%20eq%20%27${var.arm_sku_name}%27"
    product_name = "contains%28productName%2C+%27Windows%27%29%20eq%20false" # false for non Windows VMs


    # find spot price for arm_sku_name
    url = "${local.domain}?skip=0&$filter=${local.arm_region_name}%20and%20${local.service_name}%20and%20${local.meter_name}%20and%20${local.arm_sku_name}%20and%20${local.product_name}"
    items = jsondecode(data.http.get_price.response_body)["Items"]

    data = {
        for i,v in local.items:
            "Data" => {
                                "location": var.region,
                                "arm_sku_name": var.arm_sku_name,
                                "unitPrice": v["unitPrice"],
                                "currencyCode": v["currencyCode"]
                            }
            if lookup(v, "effectiveEndDate", "N/A") == "N/A"
        }

    arm_sku_error_message = {
        "Message": "No data found. Check inputs.",
        "Region": var.region,
        "arm_sku_name": var.arm_sku_name
    }

    # list spot instances with price in given region
    instances_url = "${local.domain}?skip=0&$filter=${local.arm_region_name}%20and%20${local.service_name}%20and%20${local.meter_name}%20and%20${local.product_name}"
    instances_items = jsondecode(data.http.get_instances_in_location.response_body)["Items"]
    instances = [
        for k, v in local.instances_items:
            {
                "productName": v["productName"],
                "skuName": v["skuName"],
                "armSkuName": v["armSkuName"],                                
                 "unitPrice": v["unitPrice"]
            }
        ]

    region_error_message = [{
        "Message": "No data found. Check region.",
        "Region": var.region        
    }]
}

