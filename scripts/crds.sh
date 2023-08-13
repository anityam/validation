#! /bin/bash

 # Check if kubectl is installed
if [ ! command -v kubectl &> /dev/null ] ; then
    printf "kubectl is required for this utility, and is not installed on your machine"
    printf "please visit https://kubernetes.io/docs/tasks/tools/#kubectl to install it"
    exit 1
fi

crds_location=""
## Check if a filename is given
if [[ -z $1 ]]
then 
   echo "Storing crds in ~/.kube/validate"
   mkdir ~/.kube/validate
   crds_location="~/.kube/validate"
else
    echo "location is ${1}"
    crds_location=($1)
    ## check if the folder is present
    if [[ ! -d "$crds_location" ]]
    then
        echo "$crds_location is not a folder"
    fi
fi

# Extract CRDs from cluster
NUM_OF_CRDS=0
while read -r crd
do
    filename=${crd%% *}
    kubectl get crds "$filename" -o yaml > "$crds_location/$filename.yaml" 2>&1

    resourceKind=$(grep "kind:" "$crds_location/$filename.yaml" | awk 'NR==2{print $2}' | tr '[:upper:]' '[:lower:]')
    resourceGroup=$(grep "group:" "$crds_location/$filename.yaml" | awk 'NR==1{print $2}')

    # Save name and group for later directory organization
    CRD_GROUPS["$resourceKind"]="$resourceGroup"

    let ++NUM_OF_CRDS
done < <(kubectl get crds 2>&1 | sed -n '/NAME/,$p' | tail -n +2)
