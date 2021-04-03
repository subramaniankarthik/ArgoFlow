#!/bin/bash

# set secretkey for metallb
yq eval -i ".stringData.secretkey = \"$(openssl rand -base64 128)\"" metallb/secret.yaml

if [ -z "$1" ]
    then
        echo "no repo URL provided, using upstream"
    else
        yq e -i ".spec.source.repoURL = \"$1\"" kubeflow.yaml
        for filename in ./argocd-applications/*.yaml; do
            yq e -i ".spec.source.repoURL = \"$1\"" $filename
        done
fi
