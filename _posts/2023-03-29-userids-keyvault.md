---
date: 2023-03-29T12:00:00.000Z
layout: post
title: Knowing oneself 
subtitle: 'Finding your UserID in AD with limited permissions.'
image: /images/2023-03-29-userids-keyvault/pexels-thiago-matos-3022456.png
image_source: Thiago Matos on Pexels
category: Azure
tags:
  - Azure
  - Azure AD
  - Key Vault
author: benkettner
paginate: true
---

I had to move some secrets to an Azure Key Vault during a project. To do so, I needed to complete the following steps:

1. Activated managed identities for the Web Apps and Functions 
2. Grant permissions to read secrets from the KeyVault to these identities
3. Add Secrets to the KeyVault
4. Create KeyVault references in the Configuration settings of the Web Apps and Functions

The problem was that I had next to no permissions in the Active Direcotry of the client. That made some of the taks challenging. 

# Activating Managed Identities
This step requires creating objects in the Active Directory, so there was no way, I was able to do that, I had to ask the IT department of my client for help and had them create a managed identity for each Web App and Function that needed to access the key vault. **Lesson learned**: Include the managed identity in the bicep scripts so that they are created right from the start together with your resources. This will save you a roundtrip to the IT department at a later time. 

# Granting permissions to the Managed Identities
For this step I navigated to the Key Vault in the Azure portal. There I chose "Access policies" in the left pane to create an access policy. I selected "Get" and "List" permissions for secrets (remember the least permission principle), clicked "Next", chose "Select a principal" (the link is annoyingly hidden in the text), in the pane that opens started to search for my function name and got... nothing... Even searching the full name (copying it from the Function I wanted to grant permissions for) did not help. So I went back to the Function app, openend the "Identity" menu entry from the left pane, copied the object ID and pasted that into the search box for selecting a principal. This did the trick and enabled me to grant permissions to my functions. So far, so good. 

# Adding secrets to the KeyVault
I thought that this step was a piece of cake, but unfortunately it was what cost me the most time. The problem was that - just like my functions and Web apps - my user did not have permission to access the key vault. 

Of course I had to create an access policy to solve that. In order to do so I followed the steps I executed for the Functions and Web Apps, but when selecting the principal, again, searching for my name or email address did not help. I needed my "ObjectID" (how great it feels to be objectified)... But how to get that? A quick google search told me to navigate to the AD in the portal, click on the user list, select my user and find the ID there. But... you will have guessed it: no permission to open the user list in the Azure AD. 

I tried sveral approaches, the web search suggested, none of them worked. Until I remembered my good friend PowerShell. 

First I signed into the customers tenant
```powershell
az login --tenant "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 
``` 

Next, I tried, if my ObjectID is part of the account information:

```powershell
az account show
```

Unfortunately, the `user` section of that output contained only the attributes `name` (containing my email address) and `type`. So that did not solve my problem. Next, I tried if `az ad user show` could help but that requires a user id that I was trying to find, the help text, however, also mentioned the follwing commandlet 
```powershell 
az ad signed-in-user show
``` 
And the output of that contained a field called `id` that - fortunately - enabled me to grant permissions to myself to add the secrets to the KeyVault. 

# Referencing the KeyVault
To finalize the task, I needed to reference the secrets from the KeyVault in my AppSettings. Many of you will already know that, but if you have never seen it, I will mention it here for completeness. To reference a KeyVault secret (in the same subscription), you can just change the AppSettings value to `@Microsoft.KeyVault(VaultName=myvault;SecretName=mysecret)`. I highly recommend using this syntax rather than the URL that also contains the secret version because it facilitates key rotation. If you have followed all instructions, after saving your AppSettings, a green checkmark and the information "KeyVault reference" will show up next to your setting, showing you that this setting is now read from the Keyvault. To find all the details, [read the documentation](https://learn.microsoft.com/en-us/azure/app-service/app-service-key-vault-references?tabs=azure-cli). 
