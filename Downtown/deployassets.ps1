# Publish static assets data to the S3 bucket
# This script relies on the existence of a systemconfig.yaml file in the folder above the 
# solution folder. This should contain at least the following:
# SystemGuid: "yourguid-here-496a-bd90-27f541ff523b"
# This guid is the guid of the system that the asssets belongs to. If you are only doing front end 
# work, this guid should be provided to you by the back end team. If you are doing back end work,
# then review the Service project AWSTemplates folder for more setup information.
# Note the TenancyName parameter. This is the name of the tenancy that the configuration is for.


param([string]$BucketPrefix="config",[string]$TenancyName="downtown")
$bucketName = ""
if($bucketPrefix -ne "") {
	$bucketName = $BucketPrefix + "-"
}
if($TenancyName -ne "")
{
	$bucketName = $bucketName + $TenancyName + "-"
}
$cloudFrontPrefix = "Tenancy"

Import-Module powershell-yaml

# Load configuration from YAML file
$filePath = "../../serviceconfig.yaml"
if(-not (Test-Path $filePath))
{
	Write-Host "serviceconfig.yaml file missing. See the Service/AWSTemplate folder for more information."
	exit
}

$config = Get-Content -Path $filePath | ConvertFrom-Yaml
$SystemGuid = $config.SystemGuid
$bucketName = $bucketName + $SystemGuid
$Profile = $config.Profile

## Process each language folder. base, en-US, es-MX etc.
## Note that base is not actually a language, but a special folder that contains assets that are shared across all languages.
$assetLanguages = Get-ChildItem -Directory | Where-Object { 
	$_.Name -ne "bin" -and
	$_.Name -ne "obj"
}
foreach($assetLanguage in $assetLanguages) {
	$assetLanguageName = $assetLanguage.Name
	Write-Host "$assetLanguageName"
	$assetLanguageLength = $assetLanguage.FullName.Length

	$assetGroups = Get-ChildItem -Directory -Path $assetLanguage.FullName
	foreach($assetGroup in $assetGroups) {
		$assetGroupName = $assetGroup.Name
		Write-Host "    $assetGroupName"

		$assetGroupLength = $assetGroup.FullName.Length

		$manifest = @() # start building a new manifest
		$assets = Get-ChildItem -Path $assetGroup.FullName -Recurse | Where-Object {
			-not $_.PSIsContainer -and
			$_.Name -ne "assets-manifest.json" -and
			$_.Name -ne "version.json"
		}
		foreach ($asset in $assets) {
			$hash = Get-FileHash -Path $asset.FullName -Algorithm SHA256
			$relativePath = $asset.FullName.Substring($assetLanguageLength + 1).Replace("\", "/")
			$relativePath = $cloudFrontPrefix + "/" + $assetLanguageName +"/" + $relativePath
			$manifest += @{
				hash = "sha256-$($hash.Hash)"
				url = "$relativePath"
			}
		}
		if ($manifest.count -eq 0)  {
			$manifestJson = "[]"
		} else {
			$manifestJson = $manifest | ConvertTo-Json -Depth 10 -AsArray
		}
		
		# Write mainifest file
		$manifestFilePath = Join-Path -Path $assetGroup.FullName -ChildPath "assets-manifest.json"
		Set-Content -Path $manifestFilePath -Value "$manifestJson"

		# Get version of current contents using the hash of the generated assets-manifest.json 
		$hash = Get-FileHash -Path $manifestFilePath -Algorithm SHA256
		$versioncontent = '{ "version":"' + $hash.Hash.SubString(0,8) + '" }'
		$versionFilePath = Join-Path -Path $assetGroup.FullName -ChildPath "version.json"
		Set-Content -Path $versionFilePath -Value $versioncontent
	}

	aws s3 sync $assetLanguage.FullName s3://$bucketName/$cloudFrontPrefix/$assetLanguageName --profile $Profile

}






 