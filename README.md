# PowerShell script to run the Viva Insights Delete API

## Clone the source code 

``` git clone https://github.com/microsoft/vivainsights_copilotstudioagentsdelete.git``` 


## Inputs parameters for the script 

Mandatory parameters 
1.	App (client) ID. Find this ID in the registered app information on the Azure portal under **Application (client) ID**. If you haven't created and registered your app yet, follow the instructions [here](https://go.microsoft.com/fwlink/?linkid=2310845).
2.	Entra tenant ID. Also find this ID on the app's overview page under **Directory (tenant) ID**.

# Run the script 

Go to the specific folder 

``` cd vivainsights_copilotstudioagentsdelete/PowerShellApp ``` 

Run the script with parameters in PowerShell terminal 

1. ``` .\CopilotAgentsDelete.ps1 -clientId **** -tenantId *****```

## API that the script runs 

Sample request:
``` 
 Method: DELETE, RequestUri: 'https://api.orginsights.viva.office.com/v1.0/scopes/<tenantId>/ingress/copilotbots', Version: 1.1, Headers:
                      {
                        Content-Type: application/json
                        Authorization: Bearer <bearer token>"
                      }
``` 

**Possible errors**
1. Invalid Authorization: Response status 403 
2. No Copilot Studio agents data available to delete: Response status 404
3. Any other server errors: Response status 500

# Code of Conduct

This project has adopted the
[Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information, see the
[Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com)
with any additional questions or comments.

# License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the [MIT](LICENSE) license.

# Contributing

This project welcomes contributions and suggestions. Most contributions require you to
agree to a Contributor License Agreement (CLA) declaring that you have the right to,
and actually do, grant us the rights to use your contribution. For details, visit
https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need
to provide a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the
instructions provided by the bot. You will only need to do this once across all repositories using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

# Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.