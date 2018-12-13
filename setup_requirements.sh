#!/usr/bin/env bash

#Let's assume that we use debian-based OS

set -e

install_gcloud_sdk() {
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-get update && sudo apt-get install -y google-cloud-sdk kubectl

    gcloud init
}

install_ansible() {
    apt update && sudo apt install python-pip
    pip install ansible==2.6.8
}

install_terraform() {
    printf "Installing terraform. . .\n"
    curl -s -L https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip -o /tmp/terraform
    chmod +x /tmp/terraform
    mv /tmp/terraform /usr/local/bin
}

install_helm() {
    curl -o get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
    chmod +x get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
}

setup_gke_cluster() {
    gcloud beta container \
    clusters create "blog" --region "asia-southeast1" \
    --username "admin" --cluster-version "1.11.5-gke.4" \
    --machine-type "n1-standard-1" --image-type "COS" \
    --disk-type "pd-standard" --disk-size "100" \
    --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --network "projects/infra-222411/global/networks/default" --subnetwork "projects/infra-222411/regions/asia-southeast1/subnetworks/default" \
    --enable-autoscaling --min-nodes "1" --max-nodes "3" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair

    kubectl get nodes
}

install_ingress_to_gke() {
    mkdir -p /tmp/ingress-nginx
    pushd /tmp/ingress-nginx
      curl -o namespace.yaml https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/namespace.yaml
      curl -o rbac.yaml https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/rbac.yaml
      curl -o configmap.yaml https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/configmap.yaml
      curl -o mandatory.yaml https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
    popd
    kubectl apply -f /tmp/ingress-nginx
}

install_terraform
install_ansible
install_gcloud_sdk
# install_helm
setup_gke_cluster
install_ingress_to_gke