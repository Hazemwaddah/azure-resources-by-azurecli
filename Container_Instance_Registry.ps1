az container create -g RG-IMTD-PRD-001-DevOps \
 --name zap \
 --image owasp/zap2docker-stable \
 --command-line "tail -f /dev/null"
# 

# 
az container create -g RG-IMTD-PRD-001-DevOps \
 --name zap \
 --image myacr.azurecr.io/zap:auto \
 --cpu 2 \
 --memory 8 \
 --ip-address public \
 --os-type Linux \
 --dns-name-label mycompanyaci \
 --ports 22 80 443 \
 --registry-username myacr \
 --registry-password ObA5YzjyUfeFYwZgjmen6nyh2Vu7C+ahwI9TfwWenJ+ACRDD7COd \
 --command-line "/bin/bash -c './run.sh; tail -f /dev/null'"  
#          tail -f /dev/null; 
--azure-file-volume-account-name devopssaprd001 \
--azure-file-volume-account-key [REDACTED-STORAGE-KEY] \
--azure-file-volume-share-name devops-fs-prd-001 \
--azure-file-volume-mount-path logs \


--dns-name-label mycompanyaci \
--registry-login-server devopsacrprd001.azurecr.io \
--registry-password xlMhyrjpNaZ6Ok/EC55B24ZKypStJuCG \
--registry-username devopsacrprd001 \


az container create -g RG-IMTD-PRD-001-DevOps \
  --name devops-aci-prd-001 \
  --image myacr.azurecr.io/zap:debian_bullseye_11 \
  --cpu 2 \
  --memory 8 \
  --ip-address private \
  --os-type Linux \
  --ports 22 80 443 \
  --vnet "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/mycompany-Azure-Network/providers/Microsoft.Network/virtualNetworks/IMTD-PRD-001-Vnet" \
  --subnet "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/mycompany-Azure-Network/providers/Microsoft.Network/virtualNetworks/IMTD-PRD-001-Vnet/subnets/IMTD-PRD-001-ACISubnet" \
  --azure-file-volume-account-name devopssaprd001 \
  --azure-file-volume-account-key [REDACTED-STORAGE-KEY] \
  --azure-file-volume-share-name devops-fs-prd-002 \
  --azure-file-volume-mount-path zap \
  --command-line "tail -f /dev/null"
#
# Connect to Azure File shares
# --azure-file-volume-account-name mycompanystg \
# --azure-file-volume-account-key [REDACTED-STORAGE-KEY] \
# --azure-file-volume-share-name devops-aci-prd-001 \
# --azure-file-volume-mount-path logs \
--vnet "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/mycompany-Azure-Network/providers/Microsoft.Network/virtualNetworks/IMTD-PRD-001-Vnet" \
--subnet "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/mycompany-Azure-Network/providers/Microsoft.Network/virtualNetworks/IMTD-PRD-001-Vnet/subnets/IMTD-PRD-001-ACISubnet" \


# Adding as variables in Azure DevOps
ACI_INSTANCE_NAME           devops-aci-prd-001  
ACI_LOCATION                westeurope
ACI_RESOURCE_GROUP          RG-IMTD-PRD-001-DevOps
ACI_SHARE_NAME              devops-fs-prd-001
ACI_STORAGE_ACCOUNT         devopssaprd001    
TARGET_SCAN_ADDRESS         https://mycompany-web-54.mycompany.org/RRISDaily/login.aspx

az container create -g %ACI_RESOURCE_GROUP% -n %ACI_INSTANCE_NAME% --image owasp/zap2docker-stable --ip-address public --ports 8080 --azure-file-volume-account-name mycompanystg --azure-file-volume-account-key [REDACTED-STORAGE-KEY] --azure-file-volume-share-name devops-aci-prd-001 --azure-file-volume-mount-path /zap/wrk/ --command-line "zap.sh -daemon -host 0.0.0.0 -port 8080 -config api.key=abcd -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true"
exit 0

az storage share create -g RG-IMTD-PRD-001-DevOps \
 -n devops-fs-prd-00z \
 --account-name devopssaprd00z 
#

az container create \
  --name devops-aci-prd-001 \
  --resource-group RG-IMTD-PRD-001-DevOps \
  --image devopsacrprd001.azurecr.io/debian:Ready \
  --cpu 2 \
  --memory 8 \
  --ip-address Private \
  --vnet "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/mycompany-Azure-Network/providers/Microsoft.Network/virtualNetworks/IMTD-PRD-001-Vnet" \
  --subnet "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/mycompany-Azure-Network/providers/Microsoft.Network/virtualNetworks/IMTD-PRD-001-Vnet/subnets/IMTD-PRD-001-ACISubnet"
#  


## Deploying a Linux container
az container create -g RG-IMTD-PRD-001-DevOps \
 --name owasp \
 --image ubuntu \
 --command-line "tail -f /dev/null"
#
az container show -g RG-IMTD-PRD-001-DevOps \
 --name owasp
#



az container exec -g "CloudRG" -n "mycompany_azure_container_instance" --container-name "hello-world" --exec-command "/bin/sh"



