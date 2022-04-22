param workspaceName string
param workspaceLocation string = 'WestEurope'
var managedResourceGroupName = '${workspaceName}-managed'

resource MyDatabricksWorkspace 'Microsoft.Databricks/workspaces@2021-04-01-preview' = {
  name: workspaceName
  location: workspaceLocation
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', managedResourceGroupName)
    parameters: {
      storageAccountSkuName: {
        value: 'Standard_LRS'
      }
    }
  }
}
