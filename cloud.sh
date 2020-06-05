
# script to maintain AKS cluster
# script by arun
# az aks install-cli

echo "Create Cluster? [Y,n]"
read input

if [[ $input == "Y" || $input == "y" ]]; then
        
        echo "performing operation"
		az group create --name aksrg --location eastus
		az aks create --resource-group aksrg --name myAKSCluster --node-count 1 --generate-ssh-keys
		az aks install-cli
		az aks get-credentials --resource-group aksrg --name myAKSCluster
        kubectl get nodes -o wide
        kubectl config view
        kubectl config current-context
        echo "to open cluster : az aks browse --resource-group aksrg --name myAKSCluster"

else
        
        echo "get lost"
fi

echo "Delete Cluster? [Y,n]"

read input

if [[ $input == "Y" || $input == "y" ]]; then

        echo "deleting the cluster"

        az group delete --name aksrg --yes --no-wait

else
        echo "get lost"
fi

############

gcloud config list
gcloud info
gcloud components list

echo "Create Cluster? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "do that"
	gcloud container clusters create zeus --machine-type n1-standard-2 --num-nodes 2 --zone us-central1-c
        kubectl get nodes -o wide
        kubectl config view
        kubectl config current-context
	kubectl create secret generic hanuman --from-file zeus-python-app-2b3585417c83.json
else
        echo "don't do that"
fi

echo "Delete Cluster? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "do that"
	gcloud container clusters delete zeus --zone us-central1-c
	gcloud config configurations delete zeus
else
        echo "don't do that"
fi


#gcloud container clusters get-credentials zeus --zone us-central1-c --project zeus-python-app
