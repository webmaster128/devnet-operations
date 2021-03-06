# DevNet Operations
Kubernetes manifest and Terraform operation files and doc.

## Spinning up a cluster
Currently we support only Google Cloud setup via terraform

### Prerequisites
Tested with Terraform 0.11+, kubectl v1.11+ and gcloud SDK 209+ on OS X and Linux  
Google cloud billing account  
Valid Go installation, tested with v1.11.1  

### Setup
* Run `make variables` to set you up with sample `gcloud/export_variables.sh`, `gcloud/variables.tf` and `scripts/seed_variables.sh`
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

## Optional: deploying chatbot to a cluster
* Make sure you create chatbot-env.txt in manifests/chatbot/${networkName} out of chatbot-env.txt_example
* Edit your token secret according to README here: https://github.com/iov-one/chatbot#setup
* Make sure you invite the bot to channels for it to work
* Run `make seed_bot` to deploy the bot

## Deploying current artifacts with chatbot
* Bns bnsd: `!deploy bns bns iov1/bnsd:v0.13.0` tendermint: `!deploy bns tendermint iov1/tendermint:v0.29.1`
* Bcp bcpd: `!deploy bcp bcp iov1/bcpd:v0.13.0` tendermint: `!deploy bcp tendermint iov1/tendermint:v0.29.1`
* Faucet Bns: `!deploy bns-faucet bns-faucet iov1/iov-faucet:v0.5.1` Bcp: `!deploy bcp-faucet bcp-faucet iov1/iov-faucet:v0.5.1`

## Resetting current artifacts with chatbot
* You will ever need that if you deploy breaking changes that require persistent storage reset
* Bns: `!reset bns`
* Bcp: `!reset bcp`
