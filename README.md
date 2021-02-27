# Introduction to Crossplane in Kubernetes
How to create any resource on the cloud using Kubernetes manifests
In the Kubernetes era, all of your application blueprints are packaged into a lot of Kubernetes manifests files or maybe also packages as charts using tools like helm. So how do you create any cloud resource on the cloud? You can maybe use 
An external terraform module to create the resource. 
Use a Kubernetes Job and create the resources using AWS SDK's.
Use a bash / Python script and internally call AWS CLI commands. 

But how reliable is this? Unlike Kubernetes manifests in which the yaml file can be edited on the fly, every time an attribute changes you will have to explicitly call these dependent resources. And in the modern GitOps era having such external dependencies might not be a feasible option for your GitOps Solutions. How do we fix this then? Here comes Crossplane into the picture. Crossplane enables you to provision, compose, and consume infrastructure in any cloud service provider using the Kubernetes API. Using Crossplane you can create resources on the cloud using simple manifests and can then integrate this with your CI/CD or GitOps pipelines. Crossplane is an open-source project. It is started by Upbound and then later got adopted by the CNCF as a sandbox project.

Full article published here https://pavan1999-kumar.medium.com/introduction-to-crossplane-2f873ae0f9f3
