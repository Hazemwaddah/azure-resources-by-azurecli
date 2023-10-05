



az advisor recommendation list [--category {Cost, HighAvailability, Performance, Security}]
                               [--ids]
                               [--refresh]
                               [--resource-group]
#


az advisor recommendation list -c Cost -o table
az advisor recommendation list -c Security -o table
az advisor recommendation list -c HighAvailability -o table
az advisor recommendation list -c Performance -o table
                             #  --ids \
                             #  --refresh \
                             #  --resource-group
#

az advisor recommendation list --refresh




az advisor recommendation list -o json
az advisor recommendation list -o table
az advisor recommendation list |Select-Object * |Out-GridView
az advisor recommendation list | Where-Object {$_.Status -eq "stopped"}
az advisor recommendation list | Where-Object {$_.Impact -eq "High"} | Out-GridView

az advisor recommendation list | Where-Object {$_.impact -eq "High"} 
az advisor recommendation list |Select-Object * |Out-GridView
az advisor configuration list


az security alert list -o table 
az security alert list --output help
az security alert list --help

az security alert list |Select-Object * |Out-GridView


az security secure-scores list
az security secure-scores show -n ascScore


