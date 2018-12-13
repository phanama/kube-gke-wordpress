
# Wordpress Blog

Requirements:

1. Debian-based OS
2. Bash
3. Internet connection
4. Google account with GCP

## Set up required tools

Steps:

1. bash setup_requirements.sh
2. When prompted, set up your gcloud
3. Log in with your google account when prompted/redirected
4. Choose "Create new project"
5. Enter an arbitrary project name. For example: project-assonageovsa
6. Choose asia-southeast-1a as default zone

## Spin up your blog

Steps:

1. ./blog_up.sh wordpress
2. Enter your sudo pass

## Scale your blog during peak hour

Steps:

1. ./blog_scale.sh wordpress SCALING_FACTOR
   * example: ./blog_scale.sh wordpress 3
     this will scale your wordpress * 3

## Tools used

1. Google cloud sdk
2. Google Kubernetes Engine
3. Helm
4. Ansible
5. kube.py library from github.com/kubernetes-incubator/kubespray
6. Kubernetes Nginx Ingress Controller