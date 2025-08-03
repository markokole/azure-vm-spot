# azure-vm-spot
 
## Import module to your Terraform script

```json
module spot_node_pool {
    source          = "github.com/markokole/azure-vm-spot"
    region          = var.region
    [arm_sku_name    = var.arm_sku_name]
}
```
If only *region* is submitted, it will return a list of all spot instances in the region with its price per hour in USD. The list can be quite long.

## Outputs

Two outputs are available:
- **spots_with_price** - returns a list of all spots and prices in region
- **spot_price** - returns price for given spot instance

**All prices are are in USD and the unit of Measure is 1 hour!**

## Fetching list of all spot instances with prices in specific region

Valid request returns a response like this (_list is shortened_):
```json
spots_with_price = tolist([
 tomap({
    "armSkuName" = "Standard_D32-8s_v3"
    "productName" = "Virtual Machines DSv3 Series"
    "skuName" = "D32-8s v3 Spot"
    "skuNameUrl" = "https://learn.microsoft.com/en-us/search/?scope=Azure&terms=Standard_D32-8s_v3"
    "unitPrice" = "0.25704"
  }),
  tomap({
    "armSkuName" = "Standard_M32dms_v2"
    "productName" = "Virtual Machines MdSv2 Series"
    "skuName" = "M32dms_v2 Spot"
    "skuNameUrl" = "https://learn.microsoft.com/en-us/search/?scope=Azure&terms=Standard_M32dms_v2"
    "unitPrice" = "1.311766"
  }),
])
```
**skuNameUrl** sends you to Azure's search result page for search word armSkuName. There you can easily navigate to the size series which the selected skuName is a part of.

Invalid request returns a response like this:

```json
spots_with_price = tolist([
  {
    "Message" = "No data found. Check region."
    "Region" = "gfjh"
  },
])
```

## Fetching spot price for spot instance in region

If valid region and arm_sku_name are submitted, the output will be something like this:

```json
spot_price = tomap({
  "arm_sku_name" = "Standard_A8_v2"
  "currencyCode" = "USD"
  "region" = "swedencentral"
  "unitPrice" = "0.05985"
})
```

If one of the inputs is invalid, the output informs you:

```json
spot_price = {
  "Message" = "No data found. Check inputs."
  "Region" = "swedencentral"
  "arm_sku_name" = "Invalid_sku_name"
}
```

## Parsing spots with price output with jq

```shell
SPOTS=$(terraform output -json spots_with_price)
```
### Most expensive spot instance in the region
```shell
echo $SPOTS | jq '([ .[].unitPrice | tonumber] | max | tostring) as $m | map(select(.unitPrice== $m))'
```

### Cheapest spot instance in the region
```shell
echo $SPOTS | jq '([ .[].unitPrice | tonumber] | min | tostring) as $m | map(select(.unitPrice== $m))'
```
