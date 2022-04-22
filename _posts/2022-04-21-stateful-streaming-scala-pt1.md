---
date: 2022-04-21T12:00:00.000Z
layout: post
title: Like a river... 
subtitle: 'First steps towards stateful streaming in Databricks.'
image: /images/2022-04-21-stateful-streaming-scala-pt1/pexels-rido-alwarno-1034887.jpg
image_source: Rido Alwarno on Pexels
category: Data Processing
tags:
  - Databricks
  - Azure Databricks
  - Spark
  - Streaming
author: benkettner
paginate: true
---

At a client assignment I was tasked with developing a solution to process a stream of IoT data, evaluate a set of rules on the data stream in real time and send out messages whenever a rule was triggered. We decided on using Azure Databricks for this task, so I started researching by reading up on stream processing using Databricks and by watching some Pluralsight courses on the topic. I found that the issue comes with some challenges that are worth mentioning and so I decided to write a series of articles on the topic that highlight some of the issues we had to solve down the road to stream processing in Azure Databricks. 

# Controlling the cost

One of the first issues we had to tackle in the project was controlling the cost for the Databricks instance. Imagine our shock when, after a few days of development, we looked into the cost rundown of our subscription and found out that the managed resource group Databricks had created had amassed four-digits in cost. Most of that cost came from the storage account holding the databricks file system (DBFS). After some investigation we found out that 

1. our script was not optimal as it required a lot of writing and reading to and from the DBFS and 
2. the storage account holding the DBFS was created with a geo-redundand SKU and 
3. most of that cost was caused by copying data between the regions. 

We were able to mitigate the first point by rewriting our script. How this can be done will be covered in later posts of this series. To control the latter two, we needed to change the deployment of the databricks cluster. 

## Modifying the Databricks deployment

Unfortunately, the managed resources that databricks controls are created fully automatically upon deployment cannot be controlled when creating the cluster from the Azure portal. These resources just appear automagically and are completely beyond our control if we use the portal to create Azure Databricks. Fortunately, one of the project members (cudos, Frank!) found out that it is possible to change the SKU of the storage account holding the DBFS when working with an ARM (or Bicep) template to create the Databricks resource. 

The key is to set the `storageAccountSkuName` parameter in the template when creating the resource (see the documentation [here](https://docs.microsoft.com/en-us/azure/templates/microsoft.databricks/workspaces?tabs=bicep)). Setting the storage account SKU to `Standard_LRS` in your template will result in the storage account being created with only local redundancy instead of geo-redundancy. 

A [bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) template for creating a databricks cluster could then look like this: 

```bicep
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
```

To deploy this template, you will need to create a resource group in which you want to deploy your workspace, copy the code above to a new blank file and run `az deployment group create --resource-group <resource-group-name> --template-file <path-to-bicep>`.

Of course you can alo obtain the source files for this blogpost from our [GitHub Repository](https://github.com/data-ninja-blog/data-ninja-blog.github.io/).

## Reducing cost
You can further reduce the cost your databricks workspace creates by creating clusters that are as small as possible. So, when implementing streaming jobs, you typically will not have very compute-heavy calculations that will be executed, so you can often develop on a single node cluster instead of spinning up many nodes for your development environment. That will not only help you minimize the cost for the compute instances but also reduce the cost induced by the DBFS by nto requiring to write data to DBFS for exchange between the nodes. 

## Summing all up

So, putting it all together, you should be aware of your implementation that might utilize DBFS data movement which can create significant cost (more on programming stateful streaming jobs will be published in the next posts of this series). Furthermore, create your DBFS storage account with a locally redundant SKU to avoid geo-replication related costs by modifying the Bicep (or ARM) template as shown above. Finally, keep costs under control by creating the smalles possible clusters and scaling up if it is required. 