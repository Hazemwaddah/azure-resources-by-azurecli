# ./PostgreSQL.ps1

# Sign in to Azure
# subscription="<subscriptionId>" # add subscription here
# az account set -s $subscription # ...or use 'az login'


# Set parameter values
# Variable block
let "randomIdentifier=$RANDOM*$RANDOM"
location="Germany West Central"
resourceGroup="rg-postgresql-$randomIdentifier"
tag="create-postgresql-server-and-firewall-rule"
server="PSQL-Test-$randomIdentifier"
sku="GP_Gen5_2"
version="11"
login="azureuser"
password="xxxxxxx-$randomIdentifier"
# Specify appropriate IP address values for your environment
# to limit / allow access to the PostgreSQL server
startIp=0.0.0.0
endIp=0.0.0.0
echo "Using resource group $resourceGroup with login: $login, password: $password..."

# Create a resource group
echo "Creating $resourceGroup in $location..."
az group create --name $resourceGroup --location "$location" --tags $tag

# Create a PostgreSQL server in the resource group
# Name of a server maps to DNS name and is thus required to be globally unique in Azure.
echo "Creating $server in $location..."
az postgres server create --name $server --resource-group $resourceGroup --location "$location" \
 --admin-user $login \
 --admin-password $password \
 --sku-name $sku \
 --version $version \
 --ssl-enforcement enabled
 #--infrastructure-encryption enabled 
 #--minimal-tls-version TLS1_2
#

# Configure a firewall rule for the server 
echo "Configuring a firewall rule for $server for the IP address range of $startIp to $endIp"
az postgres server firewall-rule create --resource-group $resourceGroup --server $server --name AllowIps --start-ip-address $startIp --end-ip-address $endIp

# List firewall rules for the server
echo "List of server-based firewall rules for $server"
az postgres server firewall-rule list --resource-group $resourceGroup --server-name $server
# You may use the switch `--output table` for a more readable table format as the output.

# Get the connection information
az postgres server show --resource-group rg-postgresql-707381136 --name PSQL-Test-707381136

# Connect to the Azure Database for PostgreSQL server by using psql
psql --host=psql-test-707381136.postgres.database.azure.com --port=5432 --username=azureuser@psql-test-707381136 --dbname=AiClaim
# Password:xxxxxxxxxxxx
psql "sslmode=require host=psql-test-707381136.postgres.database.azure.com port=5432 user=azureuser@psql-test-707381136 dbname=mypgsqldb"

# Clean up resources
#az group delete --name rg-postgresql-98949380

# az postgres server update -n psql-test-178624150 -g rg-postgresql-178624150 -p Pa1717w0rD-178624150

ssh -i /.ssh/privatekey admin@20.216.36.231
sudo apt install postgresql-client-common
sudo apt-get install postgresql-client
