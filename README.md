# Validation

## Tools 
Kubectl doesn't have a validation command built in by default. So we will need a third party opensource tools to do the validation for us. We will first be working on validating resources locally without the need of any cluster access. 


## What to validate
To begin with we need to validate the structure of the template that we are feeding to the CRD(custom resource definition). We will validate if the template for the crd looks correct. This step will not validate the value supplied but will only validate if the values are supplied in the right place or not according to the crd.

### Tool for crd template validate
### Requirement 
The crd definition will be needed to validate our declaration against it. For example [istio operators crd](https://github.com/istio/istio/tree/483f3466eca1de70164dd3af33fb411d9e311c23/manifests/charts/base/crds). For a good list of maintained crd's go to [datreeio crd repo](https://github.com/datreeio/CRDs-catalog). We will use istio and flux from this repo 

## Kubeval
[kubeval](https://github.com/instrumenta/kubeval) is not currently maintained but paved the way for kubeconform

## Kubeconform
[kubeconform](https://github.com/yannh/kubeconform) is an open source tool build based on kubeval. To install 
```bash
brew install kubeconform
```

Now will validate a istio template in [right.yaml](./k8_declarations/istio/right.yaml) and [wrong.yaml](./k8_declarations/istio/wrong.yaml). The wrong has 
```yaml
- uri:
      exact: /login
```
changed to 
```yaml
- uri:
  exact: /login
```
This is the third uri match logic in the http.match section so using kubeconform now
```bash
kubeconform -schema-location crd_definition/networking.istio.io/virtualservice_v1alpha3.json k8_declarations/istio/right.yaml
```
```bash
kubeconform -schema-location crd_definition/networking.istio.io/virtualservice_v1alpha3.json k8_declarations/istio/wrong.yaml  
k8_declarations/istio/wrong.yaml - VirtualService bookinfo is invalid: problem validating schema. Check JSON formatting: jsonschema: '/spec/http/0/match/2/uri' does not validate with file:///Users/bijendrabasnet/Documents/validation/crd_definition/networking.istio.io/virtualservice_v1alpha3.json#/properties/spec/properties/http/items/properties/match/items/properties/uri/type: expected object, but got null
```

## kubectl validate
Installing kubectl validate with a go installer 
```bash
go install sigs.k8s.io/kubectl-validate@latest
```
After installation the kubectl should have a validate command
```bash
kubectl validate ./k8_declarations/istio/right.yaml --local-crds ./crd_definition 

./k8_declarations/istio/right.yaml...OK
```

and with the wrong template 
```bash
kubectl validate ./k8_declarations/istio/wrong.yaml --local-crds ./crd_definition

./k8_declarations/istio/wrong.yaml...ERROR
spec.http[0].match[2].exact: Invalid value: value provided for unknown field
```


# Reading
https://danielmangum.com/posts/how-kubernetes-validates-custom-resources/#a-starting-point 