# Validation

## Tools 
Kubectl doesn't have a validation command built in by default. So we will need a third party opensource tools to do the validation for us. We will first be working on validating resources locally without the need of any cluster access. 


## What to validate
To begin with we need to validate the structure of the template that we are feeding to the CRD(custom resource definition). We will validate if the template for the crd looks correct. This step will not validate the value supplied but will only validate if the values are supplied in the right place or not according to the crd.

### Tool for crd template validate
### Requirement 
The crd definition will be needed to validate our declaration against it. For example [istio operators crd](https://github.com/istio/istio/tree/483f3466eca1de70164dd3af33fb411d9e311c23/manifests/charts/base/crds)