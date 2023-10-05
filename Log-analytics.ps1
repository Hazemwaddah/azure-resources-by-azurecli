


# Create a resource group
az group create -n rg-monitor -l uaenorth

# Clean resources
az group delete -n rg-monitor --yes


# Create a log analytics workspace
az monitor log-analytics workspace create --resource-group
                                          --workspace-name
                                          [--capacity-reservation-level]
                                          [--ingestion-access {Disabled, Enabled}]
                                          [--location]
                                          [--no-wait]
                                          [--query-access {Disabled, Enabled}]
                                          [--quota]
                                          [--retention-time]
                                          [--sku]
                                          [--tags]
#

# Example
az monitor log-analytics workspace create \
 -g rg-monitor \
 -n log-WS \
 --ingestion-access Disabled \
 --query-access Enabled \
 --sku PerGB2018 \
 --quota 0.023 \
 --retention-time 30 \
 --no-wait
#




