# Publish the tenancy configuration data the S3 bucket holding the tenancy configuration
# This script relies on the existence of a systemconfig.yaml file in the folder above the 
# solution folder. This should contain at least the following:
# SystemGuid: "yourguid-here-496a-bd90-27f541ff523b"
# This guid is the guid of the system that the tenancy belongs to. If you are only doing front end 
# work, this guid should be provided to you by the back end team. If you are doing back end work,
# then review the Service project AWSTemplates folder for more setup information.
# Note the TenancyName parameter. This is the name of the tenancy that the configuration is for.
# The default "consumer" is our default development tenancy.

param([string]$TenancyName="consumer")

Import-Module powershell-yaml

# Load configuration from YAML file
$filePath = "..\..\serviceconfig.yaml"
if(-not (Test-Path $filePath))
{
	Write-Host "serviceconfig.yaml file missing. See the Service/AWSTemplate folder for more information."
	exit
}

$config = Get-Content -Path $filePath | ConvertFrom-Yaml
$SystemGuid = $config.SystemGuid

# This script copies the tenancy configuration data to the S3 bucket holding the tenancy configuration 
# in the folder wwwroot/_content/Tenancy. 
aws s3 cp wwwroot s3://config-$TenancyName-$SystemGuid/wwwroot/_content/Tenancy --recursive --profile lzm-dev
 