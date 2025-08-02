# azure-vm-spot
 
## Import module to your Terraform script
```json
module spot_node_pool {
    source          = "github.com/markokole/azure-vm-spot"
    location        = var.location
    arm_sku_name    = var.arm_sku_name
}
```

## Outputs

If valid location and arm_sku_name here is an example of the ouptut:

```json
data = tomap({
  "arm_sku_name" = "Standard_A8_v2"
  "currencyCode" = "USD"
  "location" = "swedencentral"
  "unitPrice" = "0.05985"
})
```

If one of the inputs is invalid, the output informs you:

```json
data = {
  "Message" = "No data found. Check inputs."
  "Region" = "swedencentral"
  "arm_sku_name" = "Invalid_Standard_A8_v2"
}
```