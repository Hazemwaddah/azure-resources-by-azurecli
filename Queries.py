# In your Python environment of choice, install the required libraries for Azure Resource Graph:
# Add the Resource Graph library for Python
pip install azure-mgmt-resourcegraph

# Add the Resources library for Python
pip install azure-mgmt-resource

# Add the CLI Core library for Python for authentication (development only!)
pip install azure-cli-core

# Add the Azure identity library for Python
pip install azure.identity

# Check each installed library
pip show azure-mgmt-resourcegraph azure-mgmt-resource azure-cli-core azure.identity


# Import Azure Resource Graph library
import azure.mgmt.resourcegraph as arg

# Import specific methods and models from other libraries
from azure.mgmt.resource import SubscriptionClient
from azure.identity import AzureCliCredential

# Wrap all the work in a function
def getresources( strQuery ):
    # Get your credentials from Azure CLI (development only!) and get your subscription list
    credential = AzureCliCredential()
    subsClient = SubscriptionClient(credential)
    subsRaw = []
    for sub in subsClient.subscriptions.list():
        subsRaw.append(sub.as_dict())
    subsList = []
    for sub in subsRaw:
        subsList.append(sub.get('subscription_id'))

    # Create Azure Resource Graph client and set options
    argClient = arg.ResourceGraphClient(credential)
    argQueryOptions = arg.models.QueryRequestOptions(result_format="objectArray")

    # Create query
    argQuery = arg.models.QueryRequest(subscriptions=subsList, query=strQuery, options=argQueryOptions)

    # Run query
    argResults = argClient.resources(argQuery)

    # Show Python object
    print(argResults)

getresources("Resources | project name, type | limit 5")
#

