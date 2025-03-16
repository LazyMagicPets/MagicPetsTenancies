# Assets
This solution is used to manage "base" static assets for the system. These assets include images, message files and other static content that is used by the applications in the system.

The Assets project contains the assets that are common to all tenancies in the system. Tenancy projects contain assets that are specific to a tenancy.

The Store project contains the initial assets used create a store tenant content.

Note that their is no Consumer project becuase there is only one consumer tenant.

## Tenancies

This solution contains two projects for each test tenancy in the system.
- tenancy - contains the current tenancy configuration
- tenancy-preview - contains the preview tenancy configuration

Use the Deploy-AssetsAws powershell cmdlet to deploy assets to the tenancy S3 buckets (see LzAws module).

## Development versus Test and Production
This solution is designed to be deployed to a development environment. Test and Production environments will often require more advanced asset management and deployment strategies.

A CI/CD pipeline would be a good way to manage the deployment of assets to test and production environments from independent repositories.

Or, the assets in the tenancy S3 buckets might be directly managed by your application. 

Ultimately, the best approach will depend on your specific requirements. This solution is designed to be a quick and easy way to deploy assets to a development environment. 

## CloudFront distributions

## Assets configuration 

In addition to tenancy configurations, we also have assets configurations. These assets are in the Assets project and provide core assets to all applications in the system.

## Configuration folder hiearchy
Both tenancies and assets have the similar folder structure. 
Assets:
```
Assets
  StoreApp
    imgs
  StoreApp-en-US
  StoreApp-ex-MX
  ConsumerApp
    imgs
  ConsumerApp-en-US
  ConsumerApp-ex-MX
```
Tenancy:
```
Tenancy
  StoreApp
	imgs
  StoreApp-en-US
  StoreApp-ex-MX
  ConsumerApp
	imgs
  ConsumerApp-en-US
  ConsumerApp-ex-MX
```

## Message Files 

The system supports multi-lingual messages. Standard Microsoft culture names are used to identify the "sets" of message files. 

For example, the ```Assets/StoreApp-en-US``` folder contains the English (United States) message files for the StoreApp.
```
  assets-manifest.json -- contains the list of assets in the folder
  Messages.en-US.json -- a message files document
  version.json -- contains the version of the assets
```

We implement a robust client side caching scheme to ensure that assets are only downloaded when they are needed or have changed. The version.json files is used to determine if the assets need to be downloaded. The version.json file is updated, if necessary, by the PowerShell deployment scripts.



