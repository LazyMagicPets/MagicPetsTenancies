# Tenancies

This solution contains one project for each tenancy in the system. These projects hold the assets specific to the tenancy. 

Use the deployall.ps1 script to deploy all the tenancy data to the tenancy s3 buckets.

Under each tenancy project, there is a deployassets.ps1 file that can be used to deploy assets in that project.

## Development versus Test and Production
This solution is designed to be deployed to a development environment. Test and Production environments will often require more advanced asset management and deployment strategies.

A CI/CD pipeline would be a good way to manage the deployment of assets to test and production environments from independent repositories.

Or, the assets in the tenancy S3 buckets might be directly managed by your application. 

Ultimately, the best approach will depend on your specific requirements. This solution is designed to be a quick and esy way to deploy assets to a development environment. 