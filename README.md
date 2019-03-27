# DevNet Operations
Kubernetes manifest and Terraform operation files and doc.

## Spinning up a cluster
Currently we support only Google Cloud setup via terraform

### Prerequisites
Tested with Terraform 0.11+, kubectl v1.11+ and gcloud SDK 209+ on OS X and Linux  
Google cloud billing account  
Valid Go installation, tested with v1.11.1  

### Setup
* Run `make variables` to set you up with sample `gcloud/export_variables.sh`, `gcloud/variables.tf` and `scripts/seed_variables.shkubebot.go
`
* Modify these files as suggested in comments to each variable  
* Make sure all the generated paths like terraform plans/state and account are pointing to a secure place and not `/tmp`  
* Run `make setup_cluster`
* Enjoy your newly created Kubernetes cluster on Gcloud!

## Deploying a testnet to a cluster
* Make sure you add a faucet secret in manifests/${app_type}/bns-faucet-secret.yaml
* Make sure you set up scripts/seed_variables.sh according to comments in seed_variables.sh_example
* You will need to create your own overlay similar to manifests/${app_type}/zebranet
* Run `make deps`
* Run `make seed_cluster`
* Enjoy your testnet!
* p2p external ip can be looked up `kubectl get service bns-p2p`

## (K)ustomizing things
* A good starting point is to go through examples (here)[https://github.com/kubernetes-sigs/kustomize/tree/master/examples]
* There are comments in `manifests/weave/` base and zebranet kuztomization.yaml

## Optional: deploying kubebot to a cluster
* Make sure you create kubebot-env.txt in manifests/kubebot/${networkName} out of kubebot-env.txt_example
* Edit your token secret according to README here: https://github.com/iov-one/kubebot#setup
* Edit your channel secret to represent channels you want your bot to watch on, it could be one channel or a list of channels separated by space, e.g. `#frontend #backend`
* Make sure you invite the bot to these channels for it to work
* Run `make seed_bot` to deploy the bot