# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
<#
 .Synopsis
    Runs the Viva Insights Delete API to delete Microsoft Copilot Studio custom agents data in Viva Insights.
    
 .Description
    This script instructs the Viva Insights service to delete Microsoft Copilot Studio agents data and stop further data processing. After successfully running the script, Advanced insights users won't be able to run the Copilot Studio custom agents report. This action is irreversible.

 .Parameter ClientId
   App (client) ID. Find this ID in the registered app information on the Azure portal under **Application (client) ID**. If you haven't created and registered your app yet, follow the instructions at https://go.microsoft.com/fwlink/?linkid=2310845 to register a new app in Azure.

 .Parameter TenantId
    Entra tenant ID. Also find this ID on the app's overview page under **Directory (tenant) ID**.

  .Example
    .\CopilotAgentsDelete.ps1 -clientId **** -tenantId *****
#>

# Parameter block
param
(
    [Parameter(Position = 0, Mandatory = $true, HelpMessage = "AppId/Client ID")]
    [string] $clientId,

    [Parameter(Position = 1, Mandatory = $true, HelpMessage = "Entra tenant ID")]
    [string] $tenantId
);

# Install Nuget as a valid Package Management provider
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    try {
        Install-PackageProvider -Name NuGet -Force -ErrorAction Stop
    }
    catch {
        Write-Host "Failed to install the NuGet package provider. Exiting script." -ForegroundColor Red
        Write-Host "For troubleshooting steps, visit: https://learn.microsoft.com/en-us/powershell/module/packagemanagement/install-packageprovider" -ForegroundColor Yellow
        exit 1
    }
}

# Install and import the MSAL.PS module
if (-not (Get-Module -ListAvailable -Name MSAL.PS)) {
    try {
        Install-Module -Name MSAL.PS -Force -Scope CurrentUser -ErrorAction Stop
    }
    catch {
        Write-Host "Failed to install the MSAL.PS module. Exiting script." -ForegroundColor Red
        Write-Host "For troubleshooting steps, visit: https://learn.microsoft.com/en-us/powershell/module/powershellget/install-module" -ForegroundColor Yellow
        exit 1
    }
}

try {
    Import-Module MSAL.PS -ErrorAction Stop
}
catch {
    Write-Host "Failed to import the MSAL.PS module. Exiting script." -ForegroundColor Red
    Write-Host "For troubleshooting steps, visit: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module" -ForegroundColor Yellow
    exit 1
}

# Check if the input parameters are valid GUIDs
$clientIdGuid = [System.Guid]::Empty
$tenantIdGuid = [System.Guid]::Empty

if (-not [System.Guid]::TryParse($clientId, [ref]$clientIdGuid) -or -not [System.Guid]::TryParse($tenantId, [ref]$tenantIdGuid)) {
    Write-Host "The ClientId or the TenantId is not a valid Guid.`nPlease go through the process again." -ForegroundColor Red
    exit 1
}

# Get authentication token interactively
try {
    $authParams = @{
        ClientId    = $clientIdGuid
        TenantId    = $tenantIdGuid
        Scopes      = "9d827643-d003-4cca-9dc8-71213a8f1644" + "/.default"
        Interactive = $true
    }

    $authResult = Get-MsalToken @authParams
    if (-not $authResult) {
        Write-Host "Failed to obtain authentication token. Exiting script." -ForegroundColor Red
        exit 1
    }
    }
catch {
    Write-Error "An error occurred while attempting to obtain the authentication token. Please check your Client ID, Tenant ID, and network connectivity. Error details: $_"
    exit 1
}

# Set up request headers with the access token
$headers = @{
    "Authorization" = "Bearer $($authResult.AccessToken)"
    "Content-Type" = "application/json"
}

$apiBaseUrl = "https://api.orginsights.viva.office.com/v1.0/"
$deleteEndpoint = "${apiBaseUrl}scopes/${tenantId}/ingress/copilotbots"

# Final confirmation before executing delete operation
Write-Host "`nPreparing to delete Copilot Studio agents data from tenant: $tenantId" -ForegroundColor Yellow
$finalConfirmation = Read-Host "Type 'YES' to confirm deletion (or anything else to cancel)"

if ($finalConfirmation -ne "YES") {
    Write-Host "Operation canceled by user." -ForegroundColor Red
    exit 0
}

try {
    Write-Host "Executing delete operation..." -ForegroundColor Yellow
    Invoke-RestMethod -Uri $deleteEndpoint -Headers $headers -Method Delete
    Write-Host "SUCCESS: Copilot Studio agents data has been successfully deleted, and no new data will be processed by Viva Insights!" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Failed to delete Copilot Studio agents data." -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            $reader.Close()
            Write-Host "Error details: $responseBody" -ForegroundColor Red
        }
        catch {
            Write-Host "Could not retrieve detailed error message." -ForegroundColor Red
        }
    }
    
    if ($_.ErrorDetails.Message) {
        Write-Host "Error details: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    
    exit 1
}
