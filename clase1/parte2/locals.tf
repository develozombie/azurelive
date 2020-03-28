locals {
    #Debe ser único, ejemplo, alias = "jyapur"
    alias = ""
    #ejemplo, region = "East US 2"
    region = "East US"
    #az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscriptionID>/resourceGroups/<resourceGroupName>"
}
