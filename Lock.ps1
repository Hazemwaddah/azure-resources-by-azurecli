# --lock-type -t
# The type of lock restriction.
# accepted values: CanNotDelete, ReadOnly



# Create a read-only subscription level lock
az lock create --name lockName --lock-type ReadOnly



# Create a read-only resource group level lock.
az lock create --name lockName --resource-group group --lock-type ReadOnly


# Create a read-only resource level lock on a PostgreSQL DB:
az lock create --name PSQL_RO \
 --resource-group Production \
 --lock-type ReadOnly \
 --resource postgresqldb-production \
 --resource-type Microsoft.DBforPostgreSQL/servers
#

# Remove a read-only lock from a PostgreSQL DB:
az lock delete --name ReadOnly --resource-group Production \
 --resource postgresqldb-production \
 --resource-type Microsoft.DBforPostgreSQL/servers
#

# Remove a lock from a Resource group:
az lock delete --name "No editing" --resource-group rg-kv 
#

# Display properties of a certain lock:
az lock show -n "No editing" \
 -g rg-kv
#

# List out all locks on the subscription level:
az lock list


