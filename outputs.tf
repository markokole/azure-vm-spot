output data {
    value = lookup(local.data, "Data", "N/A") == "N/A" ? local.error_message : local.data["Data"]
}