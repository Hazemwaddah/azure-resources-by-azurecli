# Create WAF Policy

# Create Resource group
az group create --name rg-waf-policy --location uaenorth


# Create WAF policy
#az network application-gateway waf-policy create --name WAF-AKS
#                                                 --resource-group  rg-waf
#                                                 [--location]
#                                                 [--tags]
#                                                 [--type {Microsoft_BotManagerRuleSet, OWASP}]
#                                                 [--version {0.1, 2.2.9, 3.0, 3.1, 3.2}]

az network application-gateway waf-policy create \
   --name WAF-AKS-policy \
   --resource-group  rg-waf-policy \
   --location uaenorth \
   --type OWASP \
   --version 3.2
#

az network application-gateway waf-policy create \
   --name WAF-AKS-policy-Bot \
   --resource-group  rg-waf-policy \
   --location uaenorth \
   --type Microsoft_BotManagerRuleSet \
   --version 0.1
#