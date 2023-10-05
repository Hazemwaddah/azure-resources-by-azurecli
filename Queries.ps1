# Add the Resource Graph extension to the Azure CLI environment
az extension add --name resource-graph

# Check the extension list (note that you may have other extensions installed)
az extension list

#region Run help for graph query options
az graph query -h

# Login first with az login if not using Cloud Shell

# Run Azure Resource Graph query
az graph query -q 'Resources | project name, type | limit 5'

# Run Azure Resource Graph query with 'order by'
az graph query -q 'Resources | project name, type | limit 5 | order by name asc'

# Run Azure Resource Graph query with `order by` first, then with `limit`
az graph query -q 'Resources | project name, type | order by name asc | limit 5'
#endregion




Resources Exploration
#region Count Azure resources
Resources
| summarize count()

# CLI
az graph query -q "Resources | summarize count()"
#endregion

#region List count of resource by type
// resource types by number of resources
summarize ResourceCount=count() by type
| order by ResourceCount desc
| project ["Resource Type"]=type, ["Resource Count"]=ResourceCount

# CLI
az graph query -q 'summarize ResourceCount=count() by type | order by ResourceCount desc | project ["Resource Type"]=type, ["Resource Count"]=ResourceCount'
#endregion

#region Display All locations where you have resources
Resources
| project name, type, location
| order by name asc
| order by ['location'] asc

# CLI
az graph query -q "Resources | project name, location, type | order by name asc | order by ['location'] asc"
#endregion

#region Display All resources in a certain location
Resources
| project name, location, type
| where location =~ 'centralus'
| order by name desc

# CLI
az graph query -q "Resources | project name, location, type | where location =~ 'centralus' | order by name desc"
#endregion

#region Show resource types and API versions
Resources
| distinct type, apiVersion
| where isnotnull(apiVersion)
| order by type asc

# CLI
az graph query -q "Resources | distinct type, apiVersion | where isnotnull(apiVersion) | order by type asc"
#endregion

#region Get cost savings summary from Azure Advisor
AdvisorResources
| where type == 'microsoft.advisor/recommendations'
| where properties.category == 'Cost'
| extend
	resources = tostring(properties.resourceMetadata.resourceId),
	savings = todouble(properties.extendedProperties.savingsAmount),
	solution = tostring(properties.shortDescription.solution),
	currency = tostring(properties.extendedProperties.savingsCurrency)
| summarize
	dcount(resources),
	bin(sum(savings), 0.01)
	by solution, currency
| project solution, dcount_resources, sum_savings, currency
| order by sum_savings desc

# CLI
az graph query -q "AdvisorResources | where type == 'microsoft.advisor/recommendations' | where properties.category == 'Cost' | extend resources = tostring(properties.resourceMetadata.resourceId), savings = todouble(properties.extendedProperties.savingsAmount), solution = tostring(properties.shortDescription.solution), currency = tostring(properties.extendedProperties.savingsCurrency) | summarize dcount(resources), bin(sum(savings), 0.01) by solution, currency | project solution, dcount_resources, sum_savings, currency | order by sum_savings desc"
#endregion

#region Show Defender for Cloud plan pricing tier per subscription
SecurityResources
| where type == 'microsoft.security/pricings'
| project Subscription= subscriptionId, Azure_Defender_plan= name, Status= properties.pricingTier

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/pricings' | project Subscription= subscriptionId, Azure_Defender_plan= name, Status= properties.pricingTier"
#endregion




Recommendations
#region List Microsoft Defender for Cloud recommendations
# Returns all Microsoft Defender for Cloud assessments, organized in tabular manner with field per property.
# The query uses 'project' to show the listed properties in the results. You can add or remove properties.
# Click the "Run query" command above to execute the query and see results.
SecurityResources
| where type == 'microsoft.security/assessments'
| extend resourceId=id,
	recommendationId=name,
	recommendationName=properties.displayName,
	source=properties.resourceDetails.Source,
	recommendationState=properties.status.code,
	description=properties.metadata.description,
	assessmentType=properties.metadata.assessmentType,
	remediationDescription=properties.metadata.remediationDescription,
	policyDefinitionId=properties.metadata.policyDefinitionId,
	implementationEffort=properties.metadata.implementationEffort,
	recommendationSeverity=properties.metadata.severity,
	category=properties.metadata.categories,
	userImpact=properties.metadata.userImpact,
	threats=properties.metadata.threats,
	portalLink=properties.links.azurePortal
| project tenantId, subscriptionId, resourceId, recommendationName, recommendationId, recommendationState, recommendationSeverity, description, remediationDescription, assessmentType, policyDefinitionId, implementationEffort, userImpact, category, threats, source, portalLink

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/assessments' | extend resourceId=id, recommendationId=name, recommendationName=properties.displayName, source=properties.resourceDetails.Source, recommendationState=properties.status.code, description=properties.metadata.description, assessmentType=properties.metadata.assessmentType, remediationDescription=properties.metadata.remediationDescription, policyDefinitionId=properties.metadata.policyDefinitionId, implementationEffort=properties.metadata.implementationEffort, recommendationSeverity=properties.metadata.severity, category=properties.metadata.categories, userImpact=properties.metadata.userImpact, threats=properties.metadata.threats, portalLink=properties.links.azurePortal | project tenantId, subscriptionId, resourceId, recommendationName, recommendationId, recommendationState, recommendationSeverity, description, remediationDescription, assessmentType, policyDefinitionId, implementationEffort, userImpact, category, threats, source, portalLink" -o yamlc
#endregion

#region Show details about a specific recommendation using recommendation id
SecurityResources
| where type == 'microsoft.security/assessments'
| extend resourceId=id,
	recommendationId=name,
	recommendationName=properties.displayName,
	source=properties.resourceDetails.Source,
	recommendationState=properties.status.code,
	description=properties.metadata.description,
	assessmentType=properties.metadata.assessmentType,
	remediationDescription=properties.metadata.remediationDescription,
	policyDefinitionId=properties.metadata.policyDefinitionId,
	implementationEffort=properties.metadata.implementationEffort,
	recommendationSeverity=properties.metadata.severity,
	category=properties.metadata.categories,
	userImpact=properties.metadata.userImpact,
	threats=properties.metadata.threats,
	portalLink=properties.links.azurePortal
| where recommendationId =~ "00c6d40b-e990-6acf-d4f3-471e747a27c4"
| project resourceId, recommendationName, recommendationId, recommendationState, recommendationSeverity, description, remediationDescription, assessmentType, category, threats, policyDefinitionId, implementationEffort, userImpact, source, portalLink, tenantId, subscriptionId

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/assessments' | extend resourceId=id, recommendationId=name, recommendationName=properties.displayName, source=properties.resourceDetails.Source, recommendationState=properties.status.code, description=properties.metadata.description, assessmentType=properties.metadata.assessmentType, remediationDescription=properties.metadata.remediationDescription, policyDefinitionId=properties.metadata.policyDefinitionId, implementationEffort=properties.metadata.implementationEffort, recommendationSeverity=properties.metadata.severity, category=properties.metadata.categories, userImpact=properties.metadata.userImpact, threats=properties.metadata.threats, portalLink=properties.links.azurePortal | where recommendationId =~ '483f12ed-ae23-447e-a2de-a67a10db4353' | project resourceId, recommendationName, recommendationId, recommendationState, recommendationSeverity, description, remediationDescription, assessmentType, category, threats, policyDefinitionId, implementationEffort, userImpact, source, portalLink, tenantId, subscriptionId" -o yamlc
#endregion

#region List All security recommendation regarding a certain resource
securityresources
| where type =~ 'microsoft.security/locations/alerts'
| where properties.Status in ('Active')
| where properties.Severity in ('Low', 'Medium', 'High')
| extend isAzure = tostring(properties.ResourceIdentifiers) matches regex '"Type"\\s*:\\s*"AzureResource"'
| extend affectedResourceId = extract('"AzureResourceId"\\s*:\\s*"([^"]*)"', 1, tostring(properties.ResourceIdentifiers))
| extend hostName = iff(isAzure, "", extract('"HostName"\\s*:\\s*"([^"]*)"', 1, tostring(properties.Entities)))
| extend splitAffectedResourceId = split(affectedResourceId, "/")
| extend resourceNameIndex = iff(array_length(splitAffectedResourceId) > 1, array_length(splitAffectedResourceId) - 1, 0)
| extend affectedResourceName = iff(isAzure, splitAffectedResourceId[resourceNameIndex], iff(isempty(hostName), "Non-Azure", hostName))// Map subscription IDs to their names.
| extend subscription_0 = case(subscriptionId =~ '>[REDACTED-SUBSCRIPTION-ID]', 'UAE - Subscription', '')
| extend subscriptionName = case(isnotempty(subscription_0), subscription_0, '')
| extend isSubscription = array_length(splitAffectedResourceId) == 3 and affectedResourceId startswith '/subscriptions/'
| extend affectedResourceName = iff(isSubscription, subscriptionName, affectedResourceName)
| project-away isSubscription, subscriptionName, subscription_0| project-away resourceNameIndex, splitAffectedResourceId, hostName, isAzure| where affectedResourceName contains '/subscriptions/>[REDACTED-SUBSCRIPTION-ID]/resourcegroups/rg-agent-build-gws/providers/microsoft.compute/virtualmachines/cicd-agent-gwc' or affectedResourceId contains '/subscriptions/>[REDACTED-SUBSCRIPTION-ID]/resourcegroups/rg-agent-build-gws/providers/microsoft.compute/virtualmachines/cicd-agent-gwc'
| extend SeverityRank = case(
  properties.Severity == 'High', 3,
  properties.Severity == 'Medium', 2,
  properties.Severity == 'Low', 1,
  0
  )
| sort by  SeverityRank desc, tostring(properties.SystemAlertId) asc
| project-away SeverityRank
#endregion

#region List Advisor recommendations with High Severity
advisorresources
| where type == "microsoft.advisor/recommendations"
| where properties['impact'] == "High"

# CLI
az graph query -q " advisorresources | where type == 'microsoft.advisor/recommendations' | where properties['impact'] == 'High'" -o yamlc
#endregion

#region List Recommendations external StackOverFlow
securityresources
| where type == "microsoft.security/assessments"
| extend resourceId=id,    recommendationId=name,    resourceType=type,    recommendationName=properties.displayName,    source=properties.resourceDetails.Source,    recommendationState=properties.status.code,    description=properties.metadata.description,    assessmentType=properties.metadata.assessmentType,    remediationDescription=properties.metadata.remediationDescription,    policyDefinitionId=properties.metadata.policyDefinitionId,    implementationEffort=properties.metadata.implementationEffort,    recommendationSeverity=properties.metadata.severity,    category=properties.metadata.categories,    userImpact=properties.metadata.userImpact,    threats=properties.metadata.threats,    portalLink=properties.links.azurePortal
| summarize numberOfResources=count(resourceId) by tostring(recommendationName), tostring(recommendationState)
| order by tostring(recommendationState), numberOfResources desc

# CLI
az graph query -q 'securityresources | where type == "microsoft.security/assessments" | extend resourceId=id,    recommendationId=name,    resourceType=type,    recommendationName=properties.displayName,    source=properties.resourceDetails.Source,    recommendationState=properties.status.code,    description=properties.metadata.description,    assessmentType=properties.metadata.assessmentType,    remediationDescription=properties.metadata.remediationDescription,    policyDefinitionId=properties.metadata.policyDefinitionId,    implementationEffort=properties.metadata.implementationEffort,    recommendationSeverity=properties.metadata.severity,    category=properties.metadata.categories,    userImpact=properties.metadata.userImpact,    threats=properties.metadata.threats,    portalLink=properties.links.azurePortal | summarize numberOfResources=count(resourceId) by tostring(recommendationName), tostring(recommendationState) | order by tostring(recommendationState), numberOfResources desc'
#endregion

#region List Microsoft Defender recommendations
SecurityResources
| where type == 'microsoft.security/assessments'
| extend resourceId=id,
	recommendationId=name,
	recommendationName=properties.displayName,
	source=properties.resourceDetails.Source,
	recommendationState=properties.status.code,
	description=properties.metadata.description,
	assessmentType=properties.metadata.assessmentType,
	remediationDescription=properties.metadata.remediationDescription,
	policyDefinitionId=properties.metadata.policyDefinitionId,
	implementationEffort=properties.metadata.implementationEffort,
	recommendationSeverity=properties.metadata.severity,
	category=properties.metadata.categories,
	userImpact=properties.metadata.userImpact,
	threats=properties.metadata.threats,
	portalLink=properties.links.azurePortal
| project tenantId, subscriptionId, resourceId, recommendationName, recommendationId, recommendationState, recommendationSeverity, description, remediationDescription, assessmentType, policyDefinitionId, implementationEffort, userImpact, category, threats, source, portalLink

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/assessments' | extend resourceId=id, recommendationId=name, recommendationName=properties.displayName, source=properties.resourceDetails.Source, recommendationState=properties.status.code, description=properties.metadata.description, assessmentType=properties.metadata.assessmentType, remediationDescription=properties.metadata.remediationDescription, policyDefinitionId=properties.metadata.policyDefinitionId, implementationEffort=properties.metadata.implementationEffort, recommendationSeverity=properties.metadata.severity, category=properties.metadata.categories, userImpact=properties.metadata.userImpact, threats=properties.metadata.threats, portalLink=properties.links.azurePortal | project tenantId, subscriptionId, resourceId, recommendationName, recommendationId, recommendationState, recommendationSeverity, description, remediationDescription, assessmentType, policyDefinitionId, implementationEffort, userImpact, category, threats, source, portalLink" -o yamlc
#endregion

#region List Microsoft Defender recommendations
securityresources
        | where type == "microsoft.security/assessments" or type == "microsoft.security/assessments/governanceassignments"
        | where name !in('dabc9bc4-b8a8-45bd-9a5a-43000df8aa1c'
    ,'c0cb17b2-0607-48a7-b0e0-903ed22de39b'
    ,'6240402e-f77c-46fa-9060-a7ce53997754'
    ,'fde1c0c9-0fd2-4ecc-87b5-98956cbc1095'
    ,'0354476c-a12a-4fcc-a79d-f0ab7ffffdbb'
    ,'20606e75-05c4-48c0-9d97-add6daa2109a'
    ,'1ff0b4c9-ed56-4de6-be9c-d7ab39645926'
    ,'050ac097-3dda-4d24-ab6d-82568e7a50cf') 
        | where subscriptionId in (">[REDACTED-SUBSCRIPTION-ID]")
        | extend source = iff(type == "microsoft.security/assessments", trim(' ', tolower(tostring(properties.resourceDetails.Source))), dynamic(null))
        | extend resourceId = iff(type == "microsoft.security/assessments", trim(" ", tolower(tostring(case(source =~ "azure", properties.resourceDetails.Id,
            (type == "microsoft.security/assessments" and (source =~ "aws" and isnotempty(tostring(properties.resourceDetails.ConnectorId)))), properties.resourceDetails.Id,
            (type == "microsoft.security/assessments" and (source =~ "gcp" and isnotempty(tostring(properties.resourceDetails.ConnectorId)))), properties.resourceDetails.Id,
            source =~ "aws", properties.resourceDetails.AzureResourceId,
            source =~ "gcp", properties.resourceDetails.AzureResourceId,
            extract("^(.+)/providers/Microsoft.Security/assessments/.+$",1,id)
            )))), dynamic(null))
        | extend isAssessment = iff(type == "microsoft.security/assessments", 1, 0)
        | extend isAssignment = iff(type == "microsoft.security/assessments/governanceassignments", 1, 0)
        | extend assessmentId = iff(type == "microsoft.security/assessments", id, dynamic(null))
        | extend assignedResourceId = iff(type == "microsoft.security/assessments/governanceassignments", tostring(properties.assignedResourceId), dynamic(null))
        | extend idForSummarize = iff(isAssessment == 1, tolower(assessmentId), tolower(assignedResourceId))
        | extend assessmentKey = iff(type == "microsoft.security/assessments", name, dynamic(null))
        | extend assessmentDisplayName = iff(type == "microsoft.security/assessments", tostring(properties.displayName), dynamic(null))
        | extend displayName = assessmentDisplayName
        | project-away assessmentDisplayName
        | extend statusCode = iff(type == "microsoft.security/assessments", tostring(properties.status.code), dynamic(null))
        | extend isUnhealthy = iff(statusCode == "Unhealthy", 1, 0)
        | extend maturityLevel = iff(type == "microsoft.security/assessments", case(
                    isnull(properties.metadata.preview), "GA",
                    tobool(properties.metadata.preview), "Preview",
                    "GA"), dynamic(null))
        | extend statusPerInitiative = todynamic(properties.statusPerInitiative)
        | extend regexResourceId = iff(type == "microsoft.security/assessments", extract_all(@"/providers/([^/]+)(?:/([^/]+)/[^/]+(?:/([^/]+)/[^/]+)?)?/([^/]+)/[^/]+$", resourceId), dynamic(null))
        | extend regexResourceType = iff(type == "microsoft.security/assessments", regexResourceId[0], dynamic(null))
        | extend providerName = iff(type == "microsoft.security/assessments", regexResourceType[0], dynamic(null))
        | extend mainType = iff(type == "microsoft.security/assessments", case(regexResourceType[1] !~ "", strcat("/",regexResourceType[1]), ""), dynamic(null))
        | extend extendedType = iff(type == "microsoft.security/assessments", case(regexResourceType[2] !~ "", strcat("/",regexResourceType[2]), ""), dynamic(null))
        | extend resourceType = iff(type == "microsoft.security/assessments", case(regexResourceType[3] !~ "", strcat("/",regexResourceType[3]), ""), dynamic(null))
        | extend typeFullPath = iff(type == "microsoft.security/assessments", case(
                array_length(split(resourceId, '/')) == 3, 'subscription',
                array_length(split(resourceId, '/')) == 5, 'resourcegroups',
                (type == "microsoft.security/assessments" and (source =~ "gcp" and isnotempty(tostring(properties.resourceDetails.ConnectorId)))) or (type == "microsoft.security/assessments" and (source =~ "aws" and isnotempty(tostring(properties.resourceDetails.ConnectorId)))), tolower(strcat(providerName, mainType, "/", tostring(properties.additionalData.ResourceProvider), tostring(properties.additionalData.ResourceType))),
                strcat(providerName, mainType, extendedType, resourceType)), dynamic(null))
        | extend severity = iff(type == "microsoft.security/assessments", tostring(properties.metadata.severity), dynamic(null))
        | extend severityNumber = iff(type == "microsoft.security/assessments", case(
                    severity == "Low", 1,
                    severity == "Medium", 2,
                    severity == "High", 3,
                    dynamic(null)
                ), dynamic(null))
        | extend environment = iff(type == "microsoft.security/assessments", case(
                    source == "azure" or source == "onpremise", "Azure",
                    source == "aws", "AWS",
                    source == "gcp", "GCP",
                    dynamic(null)
                ), dynamic(null))
| where ((environment =~ "Azure")) or (isAssessment == 0)
        | extend dueDate = iff(type == "microsoft.security/assessments/governanceassignments", todatetime(properties.remediationDueDate), dynamic(null))
        | extend eta = iff(type == "microsoft.security/assessments/governanceassignments", todatetime(properties.remediationEta.eta), dynamic(null))
        | extend govCompletionStatus = iff(type == "microsoft.security/assessments/governanceassignments", case(
                            isnull(todatetime(properties.remediationDueDate)), "NoDueDate",
                            // We round up the current date time to be the start of the day, as the due date is inclusive
                            todatetime(properties.remediationDueDate) >= bin(now(), 1d), "OnTime",
                            "Overdue"
                        ), dynamic(null))
        | extend isGracePeriod = iff(type == "microsoft.security/assessments/governanceassignments", iff(govCompletionStatus == "OnTime", tobool(properties.isGracePeriod), false), dynamic(null))
        | summarize 
                    statusPerInitiative = anyif(statusPerInitiative, isAssessment == 1),
                    source = anyif(source, isAssessment == 1),
                    assessmentKey = anyif(assessmentKey, isAssessment == 1),
                    resourceId = anyif(resourceId, isAssessment == 1),
                    displayName = anyif(displayName, isAssessment == 1),
                    statusCode = anyif(statusCode, isAssessment == 1),
                    maturityLevel = anyif(maturityLevel, isAssessment == 1),
                    severity = anyif(severity, isAssessment == 1),
                    severityNumber = anyif(severityNumber, isAssessment == 1),
                    environment = anyif(environment, isAssessment == 1),
                    isUnhealthy = anyif(isUnhealthy, isAssessment == 1),
                    typeFullPath = anyif(typeFullPath, isAssessment == 1),
                    dueDate = anyif(dueDate, isAssignment == 1),
                    eta = anyif(eta, isAssignment == 1),
                    isGracePeriod = anyif(isGracePeriod, isAssignment == 1),
                    govCompletionStatus = anyif(govCompletionStatus, isAssignment == 1),
                    hasAssignment = max(isAssignment),
                    hasAssessmentData = sum(isAssessment) by idForSummarize
        | where hasAssessmentData > 0
        | mv-expand statusPerInitiative limit 400
        | extend policyInitiativeName = tostring(statusPerInitiative.policyInitiativeName)
        | extend now = now()
        | extend completionStatus = case(
            isUnhealthy == 0, "Completed", 
            govCompletionStatus == "Overdue", "Overdue",
            govCompletionStatus == "OnTime", "OnTime",
            "Unassigned")
        | extend completionStatusNumber = case(
            completionStatus == "Completed", 0,
            completionStatus in ("Unassigned", "Unhealthy"), 1,
            completionStatus == "OnTime", 2,
            completionStatus == "Overdue", 3,
            -1)
        | summarize initiatives = make_set_if(policyInitiativeName, isnotempty(policyInitiativeName)),
                    //source = any(source),
                    assessmentKey = any(assessmentKey),
                    displayName = any(displayName),
                    statusCode = any(statusCode),
                    maturityLevel = any(maturityLevel),
                    severity = any(severity),
                    severityNumber = any(severityNumber),
                    environment = any(environment),
                    dueDate = any(dueDate),
                    eta = any(eta),
                    isGracePeriod = any(isGracePeriod),
                    typeFullPath = any(typeFullPath),
                    completionStatus = any(completionStatus),
                    completionStatusNumber = any(completionStatusNumber) by idForSummarize
        | summarize resourceCount = count(),
                    environments = make_set(environment),
                    displayName = any(displayName),
                    maturityLevel = any(maturityLevel),
                    initiatives = make_set(initiatives),
                    resourceTypes = make_set(typeFullPath),
                    severity = any(severity),
                    severityNumber = any(severityNumber),
                    dueDate = min(dueDate),
                    eta = min(eta),
                    isGracePeriod = iff(sum(isGracePeriod) > 0, 1, 0),
                    completionStatusNumber = max(completionStatusNumber) by assessmentKey, statusCode
        | extend statusAndCount = pack("statusCode", statusCode, "resourceCount", resourceCount)
        | summarize statusAndCount = make_list(statusAndCount),
                    resourceCount = sum(resourceCount),
                    environments = make_set(environments),
                    displayName = any(displayName),
                    maturityLevel = any(maturityLevel),
                    initiatives = make_set(initiatives),
                    severity = any(severity),
                    severityNumber = any(severityNumber),
                    dueDate = min(dueDate),
                    eta = min(eta),
                    isGracePeriod = iff(sum(isGracePeriod) > 0, 1, 0),
                    resourceTypes = make_set(resourceTypes),
                    completionStatusNumber = max(completionStatusNumber) by assessmentKey
        | extend completionStatus = case(
            completionStatusNumber == 0, "Completed",
            completionStatusNumber == 1, "Unassigned",
            completionStatusNumber == 2, "OnTime",
            completionStatusNumber == 3, "Overdue",
            "Unknown")
        | order by severityNumber desc
            | extend controlsData = dynamic([])
            | order by severityNumber desc
#

#endregion

#region List Secure score controls
SecurityResources
| where type == 'microsoft.security/securescores/securescorecontrols'
| extend controlName=properties.displayName,
	controlId=properties.definition.name,
	notApplicableResourceCount=properties.notApplicableResourceCount,
	unhealthyResourceCount=properties.unhealthyResourceCount,
	healthyResourceCount=properties.healthyResourceCount,
	percentageScore=properties.score.percentage,
	currentScore=properties.score.current,
	maxScore=properties.definition.properties.maxScore,
	weight=properties.weight,
	controlType=properties.definition.properties.source.sourceType,
	controlRecommendationIds=properties.definition.properties.assessmentDefinitions
| project controlName, unhealthyResourceCount, healthyResourceCount, notApplicableResourceCount, percentageScore, currentScore, maxScore, weight, controlType, controlRecommendationIds, controlId

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/securescores/securescorecontrols' | extend controlName=properties.displayName, controlId=properties.definition.name, notApplicableResourceCount=properties.notApplicableResourceCount, unhealthyResourceCount=properties.unhealthyResourceCount, healthyResourceCount=properties.healthyResourceCount, percentageScore=properties.score.percentage, currentScore=properties.score.current, maxScore=properties.definition.properties.maxScore, weight=properties.weight, controlType=properties.definition.properties.source.sourceType, controlRecommendationIds=properties.definition.properties.assessmentDefinitions | project controlName, unhealthyResourceCount, healthyResourceCount, notApplicableResourceCount, percentageScore, currentScore, maxScore, weight, controlType, controlRecommendationIds, controlId"
#endregion

#region List more details about a specific Secure score control
SecurityResources
| where type == 'microsoft.security/securescores/securescorecontrols'
| extend controlName=properties.displayName,
	controlId=properties.definition.name,
	notApplicableResourceCount=properties.notApplicableResourceCount,
	unhealthyResourceCount=properties.unhealthyResourceCount,
	healthyResourceCount=properties.healthyResourceCount,
	percentageScore=properties.score.percentage,
	currentScore=properties.score.current,
	maxScore=properties.definition.properties.maxScore,
	weight=properties.weight,
	controlType=properties.definition.properties.source.sourceType,
	controlRecommendationIds=properties.definition.properties.assessmentDefinitions
| where controlId =~ 'a9909064-42b4-4d34-8143-275477afe18b'
| project controlName, unhealthyResourceCount, healthyResourceCount, notApplicableResourceCount, percentageScore, currentScore, maxScore, weight, controlType, controlRecommendationIds, controlId

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/securescores/securescorecontrols' | extend controlName=properties.displayName, controlId=properties.definition.name, notApplicableResourceCount=properties.notApplicableResourceCount, unhealthyResourceCount=properties.unhealthyResourceCount, healthyResourceCount=properties.healthyResourceCount, percentageScore=properties.score.percentage, currentScore=properties.score.current, maxScore=properties.definition.properties.maxScore, weight=properties.weight, controlType=properties.definition.properties.source.sourceType, controlRecommendationIds=properties.definition.properties.assessmentDefinitions | where controlId =~ 'a9909064-42b4-4d34-8143-275477afe18b' | project controlName, unhealthyResourceCount, healthyResourceCount, notApplicableResourceCount, percentageScore, currentScore, maxScore, weight, controlType, controlRecommendationIds, controlId"
#endregion




Logs
#region Display logs data about a certain resource

#region Display All roles in IAM

| where ResourceGroup == "Add_Resource_Group_Name" and Resource == "Add_Resource_Type"
| where ActivityStatus == "Succeeded" 
| project ResourceGroup, Resource, CreatedBy = Caller, CreationTime = TimeGenerated

#region List security logs from a day ago with Sentinel
# Display security events generated an hour ago
#
SecurityEvent  
| where TimeGenerated > ago(1h)
#
SecurityEvent  
| where TimeGenerated > ago(1h) and EventID == "4624"

# CLI
az graph query -q "SecurityEvent | where TimeGenerated > ago(1h)"
az graph query -q "SecurityEvent | where TimeGenerated > ago(1h) and EventID == '4624'"
#endregion

#region List all changes made in your Azure environment in one query using Azure Resource Graph
ResourceChanges
| join kind=inner
   (resourcecontainers
   | where type == 'microsoft.resources/subscriptions'
   | project subscriptionId, subscriptionName = name)
   on subscriptionId
| extend changeTime = todatetime(properties.changeAttributes.timestamp), targetResourceId = tostring(properties.targetResourceId),
changeType = tostring(properties.changeType), correlationId = properties.changeAttributes.correlationId,
changedProperties = properties.changes, changeCount = properties.changeAttributes.changesCount
| extend resourceName = tostring(split(targetResourceId, '/')[-1])
| extend resourceType = tostring(split(targetResourceId, '/')[-2])
| where changeTime > ago(7d)
// Change the time span as preferred, 1d(1 day/24h), 7d, 30d...
| where subscriptionName contains "UAE" // "" for all subscriptions
| order by changeType asc, changeTime desc
// Change what you sort by as prefered, type, time, subscriptionName, etc.
| project changeTime, resourceName, resourceType, resourceGroup, changeType, subscriptionName, subscriptionId, targetResourceId, 
correlationId, changeCount, changedProperties

# CLI
az graph query -q "ResourceChanges | join kind=inner    (resourcecontainers    | where type == 'microsoft.resources/subscriptions'    | project subscriptionId, subscriptionName = name)    on subscriptionId | extend changeTime = todatetime(properties.changeAttributes.timestamp), targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType), correlationId = properties.changeAttributes.correlationId, changedProperties = properties.changes, changeCount = properties.changeAttributes.changesCount | extend resourceName = tostring(split(targetResourceId, '/')[-1]) | extend resourceType = tostring(split(targetResourceId, '/')[-2]) | where changeTime > ago(7d) | where subscriptionName contains 'UAE'  | order by changeType asc, changeTime desc | project changeTime, resourceName, resourceType, resourceGroup, changeType, subscriptionName, subscriptionId, targetResourceId,  correlationId, changeCount, changedProperties"
#endregion

#region All changes in the past one day
resourcechanges
| extend changeTime = todatetime(properties.changeAttributes.timestamp), targetResourceId = tostring(properties.targetResourceId),
changeType = tostring(properties.changeType), correlationId = properties.changeAttributes.correlationId, 
changedProperties = properties.changes, changeCount = properties.changeAttributes.changesCount
| where changeTime > ago(1d)
| order by changeTime desc
| project changeTime, targetResourceId, changeType, correlationId, changeCount, changedProperties

# CLI
az graph query -q 'resourcechanges | extend changeTime = todatetime(properties.changeAttributes.timestamp), targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType), correlationId = properties.changeAttributes.correlationId, changedProperties = properties.changes, changeCount = properties.changeAttributes.changesCount | where changeTime > ago(1d) | order by changeTime desc | project changeTime, targetResourceId, changeType, correlationId, changeCount, changedProperties' -o yamlc
#endregion

#region This query returns the first five most recent Azure resource changes with the change time, change type, target resource ID, target resource type, and change details of each change record
# Login first with az login if not using Cloud Shell
# Run Azure Resource Graph query
resourcechanges 
| project properties.changeAttributes.timestamp, properties.changeType, properties.targetResourceId, properties.targetResourceType, properties.changes 
| limit 5

# CLI
az graph query -q 'resourcechanges | project properties.changeAttributes.timestamp, properties.changeType, properties.targetResourceId, properties.targetResourceType, properties.changes | limit 5'
#endregion

#region Update the query to specify a more user-friendly column name for the timestamp property
# Run Azure Resource Graph query with 'extend' to define a user-friendly name for properties.changeAttributes.timestamp 
resourcechanges 
| extend changeTime=todatetime(properties.changeAttributes.timestamp) | project changeTime, properties.changeType, properties.targetResourceId, properties.targetResourceType, properties.changes 
| limit 5

# CLI
az graph query -q 'resourcechanges | extend changeTime=todatetime(properties.changeAttributes.timestamp) | project changeTime, properties.changeType, properties.targetResourceId, properties.targetResourceType, properties.changes | limit 5'
#endregion

#region To get the most recent changes, update the query to order by the user-defined changeTime property
# Run Azure Resource Graph query with 'order by'
resourcechanges 
| extend changeTime=todatetime(properties.changeAttributes.timestamp) | project changeTime, properties.changeType, properties.targetResourceId, properties.targetResourceType, properties.changes 
| order by changeTime desc 
| limit 5

# CLI
az graph query -q 'resourcechanges | extend changeTime=todatetime(properties.changeAttributes.timestamp) | project changeTime, properties.changeType, properties.targetResourceId, properties.targetResourceType, properties.changes | order by changeTime desc | limit 5'
#endregion



Virtual Machines
#region Virtual machine discovery
Resources 
| where type =~ 'Microsoft.Compute/virtualMachines' 
| limit 4
#

# CLI
az graph query -q "Resources | where type =~ 'Microsoft.Compute/virtualMachines' | limit 4"
#endregion

#region Show all virtual machines ordered by name in descending order
Resources
| project name, location, type
| where type =~ 'Microsoft.Compute/virtualMachines'
| order by name desc

# CLI
az graph query -q "Resources | project name, location, type | where type =~ 'Microsoft.Compute/virtualMachines' | order by name desc"
#endregion

#region Count of virtual machines by availability state and Subscription Id
HealthResources
| where type =~ 'microsoft.resourcehealth/availabilitystatuses'
| summarize count() by subscriptionId, AvailabilityState = tostring(properties.availabilityState)

# CLI
az graph query -q "HealthResources | where type =~ 'microsoft.resourcehealth/availabilitystatuses' | summarize count() by subscriptionId, AvailabilityState = tostring(properties.availabilityState)"
#endregion

#region List virtual machines with their network interface and public IP
Resources 
| where type =~ 'microsoft.compute/virtualmachines' 
| extend nics=array_length(properties.networkProfile.networkInterfaces) 
| mv-expand nic=properties.networkProfile.networkInterfaces 
| where nics == 1 or nic.properties.primary =~ 'true' or isempty(nic) 
| project vmId = id, vmName = name, vmSize=tostring(properties.hardwareProfile.vmSize), nicId = tostring(nic.id) 
| join kind=leftouter ( Resources 
| where type =~ 'microsoft.network/networkinterfaces' 
| extend ipConfigsCount=array_length(properties.ipConfigurations) 
| mv-expand ipconfig=properties.ipConfigurations 
| where ipConfigsCount == 1 or ipconfig.properties.primary =~ 'true' 
| project nicId = id, publicIpId = tostring(ipconfig.properties.publicIPAddress.id)) on nicId 
| project-away nicId1 | summarize by vmId, vmName, vmSize, nicId, publicIpId 
| join kind=leftouter ( Resources | where type =~ 'microsoft.network/publicipaddresses' 
| project publicIpId = id, publicIpAddress = properties.ipAddress) on publicIpId 
| project-away publicIpId1
#

# CLI
az graph query -q "Resources | where type =~ 'microsoft.compute/virtualmachines' | extend nics=array_length(properties.networkProfile.networkInterfaces) | mv-expand nic=properties.networkProfile.networkInterfaces | where nics == 1 or nic.properties.primary =~ 'true' or isempty(nic) | project vmId = id, vmName = name, vmSize=tostring(properties.hardwareProfile.vmSize), nicId = tostring(nic.id) | join kind=leftouter ( Resources | where type =~ 'microsoft.network/networkinterfaces' | extend ipConfigsCount=array_length(properties.ipConfigurations) | mv-expand ipconfig=properties.ipConfigurations | where ipConfigsCount == 1 or ipconfig.properties.primary =~ 'true' | project nicId = id, publicIpId = tostring(ipconfig.properties.publicIPAddress.id)) on nicId | project-away nicId1 | summarize by vmId, vmName, vmSize, nicId, publicIpId | join kind=leftouter ( Resources | where type =~ 'microsoft.network/publicipaddresses'| project publicIpId = id, publicIpAddress = properties.ipAddress) on publicIpId | project-away publicIpId1"
#endregion

#region Show all virtual machines Scale sets ordered by name in descending order
Resources
| project name, location, type
| where type =~ 'Microsoft.Compute/virtualmachinescalesets'
| order by name desc

# CLI
az graph query -q "Resources | project name, location, type | where type =~ 'Microsoft.Compute/virtualmachinescalesets' | order by name desc"
#endregion



Private Endpoints
#region List All private endpoints
Resources
| where type == "microsoft.network/privateendpoints"
| project name, location, resourceGroup, subscriptionId
| order by name asc

# CLI
az graph query -q 'Resources | where type == "microsoft.network/privateendpoints" | project name, location, resourceGroup, subscriptionId | order by name asc'
#endregion



SQL Database
#region List SQL Databases and their elastic pools
Resources 
 | where type =~ 'microsoft.sql/servers/databases' \
 | project databaseId = id, databaseName = name, elasticPoolId = tolower(tostring(properties.elasticPoolId)) \
 | join kind=leftouter ( Resources | where type =~ 'microsoft.sql/servers/elasticpools' \
 | project elasticPoolId = tolower(id), elasticPoolName = name, elasticPoolState = properties.state) on elasticPoolId \
 | project-away elasticPoolId1
#

# CLI
az graph query -q "Resources | where type =~ 'microsoft.sql/servers/databases' | project databaseId = id, databaseName = name, elasticPoolId = tolower(tostring(properties.elasticPoolId)) | join kind=leftouter ( Resources | where type =~ 'microsoft.sql/servers/elasticpools' | project elasticPoolId = tolower(id), elasticPoolName = name, elasticPoolState = properties.state) on elasticPoolId | project-away elasticPoolId1"
#endregion

#region Show unassociated network security groups
Resources 
| where type =~ 'microsoft.network/networksecuritygroups' and isnull(properties.networkInterfaces) and isnull(properties.subnets) 
| project name, resourceGroup 
| sort by name asc
#

# CLI
az graph query -q "Resources | where type =~ 'microsoft.network/networksecuritygroups' and isnull(properties.networkInterfaces) and isnull(properties.subnets) | project name, resourceGroup | sort by name asc"
#endregion




Secure Score
#region Controls secure score per subscription
SecurityResources
| where type == 'microsoft.security/securescores/securescorecontrols'
| extend controlName=properties.displayName,
	controlId=properties.definition.name,
	notApplicableResourceCount=properties.notApplicableResourceCount,
	unhealthyResourceCount=properties.unhealthyResourceCount,
	healthyResourceCount=properties.healthyResourceCount,
	percentageScore=properties.score.percentage,
	currentScore=properties.score.current,
	maxScore=properties.definition.properties.maxScore,
	weight=properties.weight,
	controlType=properties.definition.properties.source.sourceType,
	controlRecommendationIds=properties.definition.properties.assessmentDefinitions
| project tenantId, subscriptionId, controlName, controlId, unhealthyResourceCount, healthyResourceCount, notApplicableResourceCount, percentageScore, currentScore, maxScore, weight, controlType, controlRecommendationIds

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/securescores/securescorecontrols' | extend controlName=properties.displayName, controlId=properties.definition.name, notApplicableResourceCount=properties.notApplicableResourceCount, unhealthyResourceCount=properties.unhealthyResourceCount, healthyResourceCount=properties.healthyResourceCount, percentageScore=properties.score.percentage, currentScore=properties.score.current, maxScore=properties.definition.properties.maxScore, weight=properties.weight, controlType=properties.definition.properties.source.sourceType, controlRecommendationIds=properties.definition.properties.assessmentDefinitions | project tenantId, subscriptionId, controlName, controlId, unhealthyResourceCount, healthyResourceCount, notApplicableResourceCount, percentageScore, currentScore, maxScore, weight, controlType, controlRecommendationIds"
#endregion

#region List Container Registry vulnerability assessment results
SecurityResources
| where type == 'microsoft.security/assessments'
| where properties.displayName contains 'Container registry images should have vulnerability findings resolved'
| summarize by assessmentKey=name //the ID of the assessment
| join kind=inner (
	securityresources
	| where type == 'microsoft.security/assessments/subassessments'
	| extend assessmentKey = extract('.*assessments/(.+?)/.*',1,  id)
) on assessmentKey
| project assessmentKey, subassessmentKey=name, id, parse_json(properties), resourceGroup, subscriptionId, tenantId
| extend description = properties.description,
	displayName = properties.displayName,
	resourceId = properties.resourceDetails.id,
	resourceSource = properties.resourceDetails.source,
	category = properties.category,
	severity = properties.status.severity,
	code = properties.status.code,
	timeGenerated = properties.timeGenerated,
	remediation = properties.remediation,
	impact = properties.impact,
	vulnId = properties.id,
	additionalData = properties.additionalData
#

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/assessments' | where properties.displayName contains 'Container registry images should have vulnerability findings resolved' | summarize by assessmentKey=name //the ID of the assessment | join kind=inner ( securityresources | where type == 'microsoft.security/assessments/subassessments' | extend assessmentKey = extract('.*assessments/(.+?)/.*',1, id) ) on assessmentKey | project assessmentKey, subassessmentKey=name, id, parse_json(properties), resourceGroup, subscriptionId, tenantId | extend description = properties.description, displayName = properties.displayName, resourceId = properties.resourceDetails.id, resourceSource = properties.resourceDetails.source, category = properties.category, severity = properties.status.severity, code = properties.status.code, timeGenerated = properties.timeGenerated, remediation = properties.remediation, impact = properties.impact, vulnId = properties.id, additionalData = properties.additionalData"
#endregion

#region Changes to a specific property value
resourcechanges
| extend provisioningStateChange = properties.changes["properties.provisioningState"], changeTime = todatetime(properties.changeAttributes.timestamp), targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType)
| where isnotempty(provisioningStateChange)and provisioningStateChange.newValue == "Succeeded"
| order by changeTime desc
| project changeTime, targetResourceId, changeType, provisioningStateChange.previousValue, provisioningStateChange.newValue

# CLI
az graph query -q 'resourcechanges | extend provisioningStateChange = properties.changes["properties.provisioningState"], changeTime = todatetime(properties.changeAttributes.timestamp), targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType) | where isnotempty(provisioningStateChange)and provisioningStateChange.newValue == "Succeeded" | order by changeTime desc | project changeTime, targetResourceId, changeType, provisioningStateChange.previousValue, provisioningStateChange.newValue'
#endregion

#region Query the latest resource configuration for resources created in the last seven days
resourcechanges
| extend targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType), changeTime = todatetime(properties.changeAttributes.timestamp)
| where changeTime > ago(7d) and changeType == "Create"
| project  targetResourceId, changeType, changeTime
| join ( Resources | extend targetResourceId=id) on targetResourceId
| order by changeTime desc
| project changeTime, changeType, id, resourceGroup, type, properties

# CLI
az graph query -q 'resourcechanges | extend targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType), changeTime = todatetime(properties.changeAttributes.timestamp) | where changeTime > ago(7d) and changeType == "Create" | project  targetResourceId, changeType, changeTime | join ( Resources | extend targetResourceId=id) on targetResourceId | order by changeTime desc | project changeTime, changeType, id, resourceGroup, type, properties' -o yamlc
#endregion

#region List Qualys vulnerability assessment results
SecurityResources
| where type == 'microsoft.security/assessments'
| where * contains 'vulnerabilities in your virtual machines'
| summarize by assessmentKey=name //the ID of the assessment
| join kind=inner (
	securityresources
	| where type == 'microsoft.security/assessments/subassessments'
	| extend assessmentKey = extract('.*assessments/(.+?)/.*',1,  id)
) on assessmentKey
| project assessmentKey, subassessmentKey=name, id, parse_json(properties), resourceGroup, subscriptionId, tenantId
| extend description = properties.description,
	displayName = properties.displayName,
	resourceId = properties.resourceDetails.id,
	resourceSource = properties.resourceDetails.source,
	category = properties.category,
	severity = properties.status.severity,
	code = properties.status.code,
	timeGenerated = properties.timeGenerated,
	remediation = properties.remediation,
	impact = properties.impact,
	vulnId = properties.id,
	additionalData = properties.additionalData
#

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/assessments' | where * contains 'vulnerabilities in your virtual machines' | summarize by assessmentKey=name //the ID of the assessment | join kind=inner ( securityresources | where type == 'microsoft.security/assessments/subassessments' | extend assessmentKey = extract('.*assessments/(.+?)/.*',1, id) ) on assessmentKey | project assessmentKey, subassessmentKey=name, id, parse_json(properties), resourceGroup, subscriptionId, tenantId | extend description = properties.description, displayName = properties.displayName, resourceId = properties.resourceDetails.id, resourceSource = properties.resourceDetails.source, category = properties.category, severity = properties.status.severity, code = properties.status.code, timeGenerated = properties.timeGenerated, remediation = properties.remediation, impact = properties.impact, vulnId = properties.id, additionalData = properties.additionalData"
#endregion



Regulatory Compliance

#region List HIPAA/HITRUST compliance controls
// Regulatory compliance CSV report query for standard "HIPAA HITRUST" 
// Change the 'complianceStandardId' column condition to select a different standard
securityresources
| where type == "microsoft.security/regulatorycompliancestandards/regulatorycompliancecontrols/regulatorycomplianceassessments"
| parse id with * "regulatoryComplianceStandards/" complianceStandardId "/regulatoryComplianceControls/" complianceControlId "/regulatoryComplianceAssessments" *
| extend complianceStandardId = replace( "-", " ", complianceStandardId)
| where complianceStandardId ==  "HIPAA HITRUST" 
| extend failedResources = toint(properties.failedResources), passedResources = toint(properties.passedResources),skippedResources = toint(properties.skippedResources)
| where failedResources + passedResources + skippedResources > 0 or properties.assessmentType == "MicrosoftManaged"
| join kind = leftouter(
securityresources
| where type == "microsoft.security/assessments") on subscriptionId, name
| extend complianceState = tostring(properties.state)
| extend resourceSource = tolower(tostring(properties1.resourceDetails.Source))
| extend recommendationId = iff(isnull(id1) or isempty(id1), id, id1)
| extend resourceId = trim(' ', tolower(tostring(case(resourceSource =~ 'azure', properties1.resourceDetails.Id,
                                                    resourceSource =~ 'gcp', properties1.resourceDetails.GcpResourceId,
                                                    resourceSource =~ 'aws' and isnotempty(tostring(properties1.resourceDetails.ConnectorId)), properties1.resourceDetails.Id,
                                                    resourceSource =~ 'aws', properties1.resourceDetails.AwsResourceId,
                                                    extract('^(.+)/providers/Microsoft.Security/assessments/.+$',1,recommendationId)))))
| extend regexResourceId = extract_all(@"/providers/[^/]+(?:/([^/]+)/[^/]+(?:/[^/]+/[^/]+)?)?/([^/]+)/([^/]+)$", resourceId)[0]
| extend resourceType = iff(resourceSource =~ "aws" and isnotempty(tostring(properties1.resourceDetails.ConnectorId)), tostring(properties1.additionalData.ResourceType), iff(regexResourceId[1] != "", regexResourceId[1], iff(regexResourceId[0] != "", regexResourceId[0], "subscriptions")))
| extend resourceName = tostring(regexResourceId[2])
| extend recommendationName = name
| extend recommendationDisplayName = tostring(iff(isnull(properties1.displayName) or isempty(properties1.displayName), properties.description, properties1.displayName))
| extend description = tostring(properties1.metadata.description)
| extend remediationSteps = tostring(properties1.metadata.remediationDescription)
| extend severity = tostring(properties1.metadata.severity)
| extend azurePortalRecommendationLink = tostring(properties1.links.azurePortal) | mvexpand statusPerInitiative = properties1.statusPerInitiative
            | extend expectedInitiative = statusPerInitiative.policyInitiativeName =~ "HIPAA HITRUST"
            | summarize arg_max(expectedInitiative, *) by complianceControlId, recommendationId
            | extend state = iff(expectedInitiative, tolower(statusPerInitiative.assessmentStatus.code), tolower(properties1.status.code))
            | extend notApplicableReason = iff(expectedInitiative, tostring(statusPerInitiative.assessmentStatus.cause), tostring(properties1.status.cause))
            | project-away expectedInitiative 
| project azurePortalRecommendationLink, complianceState, severity, remediationSteps, resourceName, resourceType, resourceId, recommendationId, recommendationName, recommendationDisplayName, description, state, resourceGroup = resourceGroup1, notApplicableReason, complianceControlId | join kind = leftouter (securityresources
| where type == "microsoft.security/regulatorycompliancestandards/regulatorycompliancecontrols"
| parse id with * "regulatoryComplianceStandards/" complianceStandardId "/regulatoryComplianceControls/" *
| extend complianceStandardId = replace( "-", " ", complianceStandardId)
| where complianceStandardId == "HIPAA HITRUST"
| where properties.state != "Unsupported"
| extend controlName = tostring(properties.description)
| project controlId = name, controlName
| distinct controlId, controlName) on $right.controlId == $left.complianceControlId
        | project-away controlId
        | distinct *
        | order by complianceState asc, severity asc
#endregion

#region Regulatory compliance assessments state
SecurityResources
| where type == 'microsoft.security/regulatorycompliancestandards/regulatorycompliancecontrols/regulatorycomplianceassessments'
| extend assessmentName=properties.description,
	complianceStandard=extract(@'/regulatoryComplianceStandards/(.+)/regulatoryComplianceControls',1,id),
	complianceControl=extract(@'/regulatoryComplianceControls/(.+)/regulatoryComplianceAssessments',1,id),
	skippedResources=properties.skippedResources,
	passedResources=properties.passedResources,
	failedResources=properties.failedResources,
	state=properties.state
| project tenantId, subscriptionId, id, complianceStandard, complianceControl, assessmentName, state, skippedResources, passedResources, failedResources
#

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/regulatorycompliancestandards/regulatorycompliancecontrols/regulatorycomplianceassessments' | extend assessmentName=properties.description, complianceStandard=extract(@'/regulatoryComplianceStandards/(.+)/regulatoryComplianceControls',1,id), complianceControl=extract(@'/regulatoryComplianceControls/(.+)/regulatoryComplianceAssessments',1,id), skippedResources=properties.skippedResources, passedResources=properties.passedResources, failedResources=properties.failedResources, state=properties.state | project tenantId, subscriptionId, id, complianceStandard, complianceControl, assessmentName, state, skippedResources, passedResources, failedResources" -o yamlc
#endregion

#region Regulatory compliance state per compliance standard
SecurityResources
| where type == 'microsoft.security/regulatorycompliancestandards'
| extend complianceStandard=name,
	state=properties.state,
	passedControls=properties.passedControls,
	failedControls=properties.failedControls,
	skippedControls=properties.skippedControls,
	unsupportedControls=properties.unsupportedControls
| project tenantId, subscriptionId, complianceStandard, state, passedControls, failedControls, skippedControls, unsupportedControls
#

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/regulatorycompliancestandards' | extend complianceStandard=name, state=properties.state, passedControls=properties.passedControls, failedControls=properties.failedControls, skippedControls=properties.skippedControls, unsupportedControls=properties.unsupportedControls | project tenantId, subscriptionId, complianceStandard, state, passedControls, failedControls, skippedControls, unsupportedControls"
#endregion

#region Compliance by resource type
PolicyResources
| where type =~ 'Microsoft.PolicyInsights/PolicyStates'
| extend complianceState = tostring(properties.complianceState)
| extend
	resourceId = tostring(properties.resourceId),
	resourceType = tolower(tostring(properties.resourceType)),
	policyAssignmentId = tostring(properties.policyAssignmentId),
	policyDefinitionId = tostring(properties.policyDefinitionId),
	policyDefinitionReferenceId = tostring(properties.policyDefinitionReferenceId),
	stateWeight = iff(complianceState == 'NonCompliant', int(300), iff(complianceState == 'Compliant', int(200), iff(complianceState == 'Conflict', int(100), iff(complianceState == 'Exempt', int(50), int(0)))))
| summarize max(stateWeight) by resourceId, resourceType
| summarize counts = count() by resourceType, max_stateWeight
| summarize overallStateWeight = max(max_stateWeight),
nonCompliantCount = sumif(counts, max_stateWeight == 300),
compliantCount = sumif(counts, max_stateWeight == 200),
conflictCount = sumif(counts, max_stateWeight == 100),
exemptCount = sumif(counts, max_stateWeight == 50) by resourceType
| extend totalResources = todouble(nonCompliantCount + compliantCount + conflictCount + exemptCount)
| extend compliancePercentage = iff(totalResources == 0, todouble(100), 100 * todouble(compliantCount + exemptCount) / totalResources)
| project resourceType,
overAllComplianceState = iff(overallStateWeight == 300, 'noncompliant', iff(overallStateWeight == 200, 'compliant', iff(overallStateWeight == 100, 'conflict', iff(overallStateWeight == 50, 'exempt', 'notstarted')))),
compliancePercentage,
compliantCount,
nonCompliantCount,
conflictCount,
exemptCount
#

#CLI 
az graph query -q "PolicyResources | where type =~ 'Microsoft.PolicyInsights/PolicyStates' | extend complianceState = tostring(properties.complianceState) | extend resourceId = tostring(properties.resourceId), resourceType = tolower(tostring(properties.resourceType)), policyAssignmentId = tostring(properties.policyAssignmentId), policyDefinitionId = tostring(properties.policyDefinitionId), policyDefinitionReferenceId = tostring(properties.policyDefinitionReferenceId), stateWeight = iff(complianceState == 'NonCompliant', int(300), iff(complianceState == 'Compliant', int(200), iff(complianceState == 'Conflict', int(100), iff(complianceState == 'Exempt', int(50), int(0))))) | summarize max(stateWeight) by resourceId, resourceType | summarize counts = count() by resourceType, max_stateWeight | summarize overallStateWeight = max(max_stateWeight), nonCompliantCount = sumif(counts, max_stateWeight == 300), compliantCount = sumif(counts, max_stateWeight == 200), conflictCount = sumif(counts, max_stateWeight == 100), exemptCount = sumif(counts, max_stateWeight == 50) by resourceType | extend totalResources = todouble(nonCompliantCount + compliantCount + conflictCount + exemptCount) | extend compliancePercentage = iff(totalResources == 0, todouble(100), 100 * todouble(compliantCount + exemptCount) / totalResources) | project resourceType, overAllComplianceState = iff(overallStateWeight == 300, 'noncompliant', iff(overallStateWeight == 200, 'compliant', iff(overallStateWeight == 100, 'conflict', iff(overallStateWeight == 50, 'exempt', 'notstarted')))), compliancePercentage, compliantCount, nonCompliantCount, conflictCount, exemptCount" -o yamlc
#endregion

#region List all non-compliant resources
PolicyResources
| where type == 'microsoft.policyinsights/policystates'
| where properties.complianceState == 'NonCompliant'

# CLI
az graph query -q "PolicyResources | where type == 'microsoft.policyinsights/policystates' | where properties.complianceState == 'NonCompliant'" -o yamlc
#endregion

#region Summarize resource compliance by state
PolicyResources
| where type == 'microsoft.policyinsights/policystates'
| extend complianceState = tostring(properties.complianceState)
| summarize count() by complianceState

# CLI
az graph query -q "PolicyResources | where type == 'microsoft.policyinsights/policystates' | extend complianceState = tostring(properties.complianceState) | summarize count() by complianceState"
#endregion

#region Summarize resource compliance by state per location
PolicyResources
| where type == 'microsoft.policyinsights/policystates'
| extend complianceState = tostring(properties.complianceState)
| extend resourceLocation = tostring(properties.resourceLocation)
| summarize count() by resourceLocation, complianceState

# CLI
az graph query -q "PolicyResources | where type == 'microsoft.policyinsights/policystates' | extend complianceState = tostring(properties.complianceState) | extend resourceLocation = tostring(properties.resourceLocation) | summarize count() by resourceLocation, complianceState"
#endregion

#region Count healthy, unhealthy, and not applicable resources per recommendation
SecurityResources
| where type == 'microsoft.security/assessments'
| extend resourceId=id,
	recommendationId=name,
	resourceType=type,
	recommendationName=properties.displayName,
	source=properties.resourceDetails.Source,
	recommendationState=properties.status.code,
	description=properties.metadata.description,
	assessmentType=properties.metadata.assessmentType,
	remediationDescription=properties.metadata.remediationDescription,
	policyDefinitionId=properties.metadata.policyDefinitionId,
	implementationEffort=properties.metadata.implementationEffort,
	recommendationSeverity=properties.metadata.severity,
	category=properties.metadata.categories,
	userImpact=properties.metadata.userImpact,
	threats=properties.metadata.threats,
	portalLink=properties.links.azurePortal
| summarize numberOfResources=count(resourceId) by tostring(recommendationName), tostring(recommendationState)

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/assessments' | extend resourceId=id, recommendationId=name, resourceType=type, recommendationName=properties.displayName, source=properties.resourceDetails.Source, recommendationState=properties.status.code, description=properties.metadata.description, assessmentType=properties.metadata.assessmentType, remediationDescription=properties.metadata.remediationDescription, policyDefinitionId=properties.metadata.policyDefinitionId, implementationEffort=properties.metadata.implementationEffort, recommendationSeverity=properties.metadata.severity, category=properties.metadata.categories, userImpact=properties.metadata.userImpact, threats=properties.metadata.threats, portalLink=properties.links.azurePortal | summarize numberOfResources=count(resourceId) by tostring(recommendationName), tostring(recommendationState)"
#endregion

#region Active Service Health event subscription impact
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = tostring(properties.EventType), status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime))
| where properties.Status == 'Active' and tolong(impactStartTime) > 1
| summarize count(subscriptionId) by name, eventType

# CLI 
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = tostring(properties.EventType), status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where properties.Status == 'Active' and tolong(impactStartTime) > 1 | summarize count(subscriptionId) by name, eventType"
#endregion

#region All active health advisory events
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime))
| where properties.Status == 'Active' and tolong(impactStartTime) > 1 and eventType == 'HealthAdvisory'

# CLI
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where properties.Status == 'Active' and tolong(impactStartTime) > 1 and eventType == 'HealthAdvisory'"
#endregion

#region All active planned maintenance events
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime))
| where properties.Status == 'Active' and tolong(impactStartTime) > 1 and eventType == 'PlannedMaintenance'

# CLI
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where properties.Status == 'Active' and tolong(impactStartTime) > 1 and eventType == 'PlannedMaintenance'"
#endregion

#region All active Service Health events
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime))
| where properties.Status == 'Active' and tolong(impactStartTime) > 1

# CLI
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where properties.Status == 'Active' and tolong(impactStartTime) > 1"
#endregion

#region All active service issue events
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime))
| where properties.Status == 'Active' and tolong(impactStartTime) > 1 and eventType == 'ServiceIssue'

# CLI
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where properties.Status == 'Active' and tolong(impactStartTime) > 1 and eventType == 'ServiceIssue'"
#endregion

#region Show resources that contain storage
Resources
| where type contains 'storage' | distinct type

# CLI
az graph query -q "Resources | where type contains 'storage' | distinct type"
#endregion

#region Get all New security alerts from the past 30 days
securityresources
| where type == "microsoft.security/locations/alerts"
| where todatetime(properties.startTimeUtc) > ago(30d) and properties.status == 'New'

# CLI
az graph query -q "securityresources | where type == 'microsoft.security/locations/alerts' | where todatetime(properties.startTimeUtc) > ago(30d) and properties.status == 'New'"
#endregion

#region Get all New security alerts from the past 30 days for IoT resource
iotsecurityresources
| where type == 'microsoft.iotsecurity/locations/devicegroups/alerts'
| where todatetime(properties.startTimeUtc) > ago(30d) and properties.status == 'New'

# CLI
az graph query -q "iotsecurityresources | where type == 'microsoft.iotsecurity/locations/devicegroups/alerts' | where todatetime(properties.startTimeUtc) > ago(30d) and properties.status == 'New'"
#endregion

#region Get All Alerts with status fired
AlertsManagementResources
| extend AlertStatus = properties.essentials.monitorCondition
| extend AlertState = properties.essentials.alertState
| extend AlertTime = properties.essentials.startDateTime
| extend AlertSuppressed = properties.essentials.actionStatus.isSuppressed
| extend Severity = properties.essentials.severity
| where AlertStatus == 'Fired'
| extend Details = pack_all()
| project id, name, subscriptionId, resourceGroup, AlertStatus, AlertState, AlertTime, AlertSuppressed, Severity, Details

# CLI
az graph query -q "AlertsManagementResources | extend AlertStatus = properties.essentials.monitorCondition | extend AlertState = properties.essentials.alertState | extend AlertTime = properties.essentials.startDateTime | extend AlertSuppressed = properties.essentials.actionStatus.isSuppressed | extend Severity = properties.essentials.severity | where AlertStatus == 'Fired' | extend Details = pack_all() | project id, name, subscriptionId, resourceGroup, AlertStatus, AlertState, AlertTime, AlertSuppressed, Severity, Details " -o yamlc
#endregion

#region Get virtual machine scale set capacity and size
Resources
| where type=~ 'microsoft.compute/virtualmachinescalesets'
| project subscriptionId, name, location, resourceGroup, Capacity = toint(sku.capacity), Tier = sku.name
| order by Capacity desc

# CLI
az graph query -q "Resources | where type=~ 'microsoft.compute/virtualmachinescalesets' | project subscriptionId, name, location, resourceGroup, Capacity = toint(sku.capacity), Tier = sku.name | order by Capacity desc" 
#endregion

#region List all extensions installed on a virtual machine
Resources
| where type == 'microsoft.compute/virtualmachines'
| extend
	JoinID = toupper(id),
	OSName = tostring(properties.osProfile.computerName),
	OSType = tostring(properties.storageProfile.osDisk.osType),
	VMSize = tostring(properties.hardwareProfile.vmSize)
| join kind=leftouter(
	Resources
	| where type == 'microsoft.compute/virtualmachines/extensions'
	| extend 
		VMId = toupper(substring(id, 0, indexof(id, '/extensions'))),
		ExtensionName = name
) on $left.JoinID == $right.VMId
| summarize Extensions = make_list(ExtensionName) by id, OSName, OSType, VMSize
| order by tolower(OSName) asc

# CLI
az graph query -q "Resources | where type == 'microsoft.compute/virtualmachines' | extend JoinID = toupper(id), OSName = tostring(properties.osProfile.computerName), OSType = tostring(properties.storageProfile.osDisk.osType), VMSize = tostring(properties.hardwareProfile.vmSize) | join kind=leftouter( Resources | where type == 'microsoft.compute/virtualmachines/extensions' | extend  VMId = toupper(substring(id, 0, indexof(id, '/extensions'))),  ExtensionName = name ) on \$left.JoinID == \$right.VMId | summarize Extensions = make_list(ExtensionName) by id, OSName, OSType, VMSize | order by tolower(OSName) asc"
#endregion

#region List available OS updates for all your machines grouped by update category
PatchAssessmentResources
| where type !has 'softwarepatches'
| extend prop = parse_json(properties)
| extend lastTime = properties.lastModifiedDateTime
| extend updateRollupCount = prop.availablePatchCountByClassification.updateRollup, featurePackCount = prop.availablePatchCountByClassification.featurePack, servicePackCount = prop.availablePatchCountByClassification.servicePack, definitionCount = prop.availablePatchCountByClassification.definition, securityCount = prop.availablePatchCountByClassification.security, criticalCount = prop.availablePatchCountByClassification.critical, updatesCount = prop.availablePatchCountByClassification.updates, toolsCount = prop.availablePatchCountByClassification.tools, otherCount = prop.availablePatchCountByClassification.other, OS = prop.osType
| project lastTime, id, OS, updateRollupCount, featurePackCount, servicePackCount, definitionCount, securityCount, criticalCount, updatesCount, toolsCount, otherCount

# CLI
az graph query -q "PatchAssessmentResources | where type !has 'softwarepatches' | extend prop = parse_json(properties) | extend lastTime = properties.lastModifiedDateTime | extend updateRollupCount = prop.availablePatchCountByClassification.updateRollup, featurePackCount = prop.availablePatchCountByClassification.featurePack, servicePackCount = prop.availablePatchCountByClassification.servicePack, definitionCount = prop.availablePatchCountByClassification.definition, securityCount = prop.availablePatchCountByClassification.security, criticalCount = prop.availablePatchCountByClassification.critical, updatesCount = prop.availablePatchCountByClassification.updates, toolsCount = prop.availablePatchCountByClassification.tools, otherCount = prop.availablePatchCountByClassification.other, OS = prop.osType | project lastTime, id, OS, updateRollupCount, featurePackCount, servicePackCount, definitionCount, securityCount, criticalCount, updatesCount, toolsCount, otherCount"
#endregion

#region List of Linux OS update installation done
PatchAssessmentResources
| where type has 'softwarepatches' and properties has 'version'
| extend machineName = tostring(split(id, '/', 8)), resourceType = tostring(split(type, '/', 0)), tostring(rgName = split(id, '/', 4)), tostring(RunID = split(id, '/', 10))
| extend prop = parse_json(properties)
| extend lTime = todatetime(prop.lastModifiedDateTime), patchName = tostring(prop.patchName), version = tostring(prop.version), installationState = tostring(prop.installationState), classifications = tostring(prop.classifications)
| where lTime > ago(7d)
| project lTime, RunID, machineName, rgName, resourceType, patchName, version, classifications, installationState
| sort by RunID

# CLI
az graph query -q "PatchAssessmentResources | where type has 'softwarepatches' and properties has 'version' | extend machineName = tostring(split(id, '/', 8)), resourceType = tostring(split(type, '/', 0)), tostring(rgName = split(id, '/', 4)), tostring(RunID = split(id, '/', 10)) | extend prop = parse_json(properties) | extend lTime = todatetime(prop.lastModifiedDateTime), patchName = tostring(prop.patchName), version = tostring(prop.version), installationState = tostring(prop.installationState), classifications = tostring(prop.classifications) | where lTime > ago(7d) | project lTime, RunID, machineName, rgName, resourceType, patchName, version, classifications, installationState | sort by RunID"
#endregion

#region List of Windows Server OS update installation done
PatchAssessmentResources
| where type has 'softwarepatches' and properties !has 'version'
| extend machineName = tostring(split(id, '/', 8)), resourceType = tostring(split(type, '/', 0)), tostring(rgName = split(id, '/', 4)), tostring(RunID = split(id, '/', 10))
| extend prop = parse_json(properties)
| extend lTime = todatetime(prop.lastModifiedDateTime), patchName = tostring(prop.patchName), kbId = tostring(prop.kbId), installationState = tostring(prop.installationState), classifications = tostring(prop.classifications)
| where lTime > ago(7d)
| project lTime, RunID, machineName, rgName, resourceType, patchName, kbId, classifications, installationState
| sort by RunID

# CLI
az graph query -q "PatchAssessmentResources | where type has 'softwarepatches' and properties !has 'version' | extend machineName = tostring(split(id, '/', 8)), resourceType = tostring(split(type, '/', 0)), tostring(rgName = split(id, '/', 4)), tostring(RunID = split(id, '/', 10)) | extend prop = parse_json(properties) | extend lTime = todatetime(prop.lastModifiedDateTime), patchName = tostring(prop.patchName), kbId = tostring(prop.kbId), installationState = tostring(prop.installationState), classifications = tostring(prop.classifications) | where lTime > ago(7d) | project lTime, RunID, machineName, rgName, resourceType, patchName, kbId, classifications, installationState | sort by RunID"
#endregion

#region List all public IP addresses
Resources
| where type contains 'publicIPAddresses' and isnotempty(properties.ipAddress)
| project properties.ipAddress
| limit 100
# 

# CLI
az graph query -q "Resources | where type contains 'publicIPAddresses' and isnotempty(properties.ipAddress) | project properties.ipAddress | limit 100"
#endregion

#region Show Defender for Cloud plan pricing tier per subscription
SecurityResources
| where type == 'microsoft.security/pricings'
| project Subscription= subscriptionId, Azure_Defender_plan= name, Status= properties.pricingTier

# CLI
az graph query -q "SecurityResources | where type == 'microsoft.security/pricings' | project Subscription= subscriptionId, Azure_Defender_plan= name, Status= properties.pricingTier"
#endregion

#region Changes to a specific property value
resourcechanges
| extend provisioningStateChange = properties.changes["properties.provisioningState"], changeTime = todatetime(properties.changeAttributes.timestamp), targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType)
| where isnotempty(provisioningStateChange)and provisioningStateChange.newValue == "Succeeded"
| order by changeTime desc
| project changeTime, targetResourceId, changeType, provisioningStateChange.previousValue, provisioningStateChange.newValue

# CLI
az graph query -q 'resourcechanges | extend provisioningStateChange = properties.changes["properties.provisioningState"], changeTime = todatetime(properties.changeAttributes.timestamp), targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType) | where isnotempty(provisioningStateChange)and provisioningStateChange.newValue == "Succeeded" | order by changeTime desc | project changeTime, targetResourceId, changeType, provisioningStateChange.previousValue, provisioningStateChange.newValue'
#endregion

#region Get all the requests where userAgent is originated from python
// Errors by user agent 
// Number of errors by user agent. 
// To create an alert for this query, click '+ New alert rule'
AzureDiagnostics
| where ResourceType == "APPLICATIONGATEWAYS" and OperationName == "ApplicationGatewayAccess" and httpStatus_d > 399
| summarize AggregatedValue = count() by userAgent_s, _ResourceId
| where userAgent_s has "python"
#endregion


#region
// Calculate time difference between AzureDiagnostics logs with the same Client IP
AzureDiagnostics
| order by TimeGenerated asc
| extend PreviousTimeGenerated = prev(TimeGenerated, 1)
| extend TimeDifference = TimeGenerated - PreviousTimeGenerated
| where clientIP_s != '' and TimeDifference < time(0.00:00:00.500)
| project TimeGenerated, clientIP_s, TimeDifference
#endregion


updates

#region List All Updates needed for cicd-agent
patchassessmentresources
| where type =~ "microsoft.compute/virtualmachines/patchAssessmentResults/softwarePatches"
| where id startswith "/subscriptions/>[REDACTED-SUBSCRIPTION-ID]/resourcegroups/rg-agent-build-gws/providers/microsoft.compute/virtualmachines/cicd-agent-gwc/patchAssessmentResults/latest/softwarePatches/"
| project id, properties

#endregion

# Count of changes by change type and subscription name
resourcechanges 
|extend changeType = tostring(properties.changeType), changeTime = todatetime(properties.changeAttributes.timestamp), targetResourceType=tostring(properties.targetResourceType)   
| summarize count() by changeType, subscriptionId  
| join (resourcecontainers | where type=='microsoft.resources/subscriptions' | project SubscriptionName=name, subscriptionId) on subscriptionId  
| project-away subscriptionId, subscriptionId1 
| order by count_ desc

Resources
| where tags.environment=~'internal'
| project name, tags

az graph query -q "Resources | where tags.environment=~'internal' | project name, tags"

az graph query -q "GuestConfigurationResources | where type =~ 'microsoft.guestconfiguration/guestconfigurationassignments' | where properties.complianceStatus == 'NonCompliant' | project id, name, resources = properties.latestAssignmentReport.resources, machine = split(properties.targetResourceId,'/')[(-1)], status = tostring(properties.complianceStatus) | extend resources = iff(isnull(resources[0]), dynamic([{}]), resources) | mvexpand resources | extend reasons = resources.reasons | extend reasons = iff(isnull(reasons[0]), dynamic([{}]), reasons) | mvexpand reasons | where machine == 'MACHINENAME' | project id, machine, name, status, resource = resources.resourceId, reason = reasons.phrase"

az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = tostring(properties.EventType), status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where properties.Status == 'Active' and tolong(impactStartTime) > 1 | summarize count(subscriptionId) by name, eventType"

# Run Azure Resource Graph query with 'extend' to define a user-friendly name for properties.changeAttributes.timestamp 
az graph query -q 'resourcechanges | extend changeTime=todatetime(properties.changeAttributes.timestamp) | project changeTime, properties.changeType, properties.targetResourceId, properties.targetResourceType, properties.changes | limit 5'

# Run Azure Resource Graph query with 'order by'
az graph query -q 'resourcechanges | extend changeTime=todatetime(properties.changeAttributes.timestamp) | project changeTime, properties.changeType, properties.targetResourceId, properties.targetResourceType, properties.changes | order by changeTime desc | limit 5'


az vm list --output yamlc
az vm list --out table
az vm list --query "[].{resource:resourceGroup, name:name, osType:osType}" -o table



