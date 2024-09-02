# Publish all the tenancy configuration data the S3 bucket holding the tenancy configuration
# This script relies on the existence of a systemconfig.yaml file in the folder above the 
# solution folder. This should contain at least the following:
# SystemGuid: "yourguid-here-496a-bd90-27f541ff523b"
# This guid is the guid of the system that the tenancy belongs to. If you are only doing front end 
# work, this guid should be provided to you by the back end team. If you are doing back end work,
# then review the Service project AWSTemplates folder for more setup information.

Import-Module powershell-yaml

# Load configuration from YAML file
$filePath = "..\serviceconfig.yaml"
if(-not (Test-Path $filePath))
{
	Write-Host "serviceconfig.yaml file missing. See the Service/AWSTemplate folder for more information."
	exit
}

$config = Get-Content -Path $filePath | ConvertFrom-Yaml
$SystemGuid = $config.SystemGuid
$Profile = $config.Profile

aws s3 cp Admin/wwwroot s3://config-admin-$SystemGuid/wwwroot/_content/Tenancy --recursive --profile $Profile
aws s3 cp Consumer/wwwroot s3://config-consumer-$SystemGuid/wwwroot/_content/Tenancy --recursive --profile $Profile
aws s3 cp Downtown/wwwroot s3://config-downtown-$SystemGuid/wwwroot/_content/Tenancy --recursive --profile $Profile
aws s3 cp Uptown/wwwroot s3://config-uptown-$SystemGuid/wwwroot/_content/Tenancy --recursive --profile $Profile
 