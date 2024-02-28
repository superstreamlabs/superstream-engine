# Helmfile Deployment for Superstream
##### This README provides guidance on how to deploy and manage Superstream microservies on Kubernetes platform.

## Prerequisites
Before you begin, ensure you have the following prerequisites installed and configured:

1. Kubernetes Cluster: You need an up-and-running Kubernetes cluster. If you don't have one, you can create a cluster on platforms like Google Kubernetes Engine (GKE), Amazon EKS, Azure AKS, or Minikube for local development.

2. kubectl: The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters. Install kubectl if you haven't already.

3. Helm: Helm is a package manager for Kubernetes that facilitates the deployment and management of applications. Install Helm if it's not already set up.

4. Helmfile: Helmfile is a declarative spec for deploying helm charts. It lets you keep descriptions of your desired state of Helm charts in a versioned YAML file. Install Helmfile if you haven't.

## Configuration
Before deploying with Helmfile, you need to configure your environment settings and any specific parameters required for your deployment. Follow these steps to set up your configuration:

Open the `environments/default.yaml` file in your preferred text editor. Add or update the necessary parameters to match your deployment requirements.

## Using Helmfile
To apply the Helmfile configurations and deploy your Kubernetes resources, follow these steps:

1. Navigate to the Helmfile Directory (where helmfile is stored):

2. Apply Helmfile Configuration:

Run the following command to apply the Helmfile configuration. This will sync your Helm releases to match the state declared in your helmfile.yaml.

``` bash
helmfile -e default apply
```
The `-e default` flag specifies the environment. Adjust this according to your Helmfile's environment configurations.

3. Verify Deployment:

After applying the Helmfile, you can verify the deployment by listing the Helm releases:

```bash
helm list
```