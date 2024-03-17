<div align="center">

<img src="https://github.com/memphisdev/superstream-helmfile/assets/70286779/5921cf13-ce6c-4888-8ed1-e602f7f60383" width="30%"><br><br>
Improve And Optimize Your Kafka In Literally Minutes.<br>
Reduce Costs and Boost Performance by 75% Without Changing a Single Component or Your Existing Kafka!

</div>

# On-prem Superstream data plane deployment
This README guides deploying and managing Superstream on-prem data plane on Kubernetes platform.

## Prerequisites
Before you begin, ensure you have the following prerequisites installed and configured:

1. Kubernetes Cluster: You need an up-and-running Kubernetes cluster. If you don't have one, you can create a cluster on platforms like Google Kubernetes Engine (GKE), Amazon EKS, Azure AKS, or Minikube for local development.

2. [kubectl](https://kubernetes.io/docs/tasks/tools/): The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters. Install kubectl if you haven't already.

3. [Helm](https://helm.sh/docs/intro/install/): Helm is a package manager for Kubernetes that facilitates the deployment and management of applications. Install Helm if it's not already set up.

4. [Helmfile](https://helmfile.readthedocs.io/en/latest/#installation): Helmfile is a declarative spec for deploying helm charts. It lets you keep descriptions of your desired state of Helm charts in a versioned YAML file. Install Helmfile if you haven't.

5. [helm-diff plugin](https://github.com/databus23/helm-diff#install) plugin shows a diff explaining what a `helm upgrade` would change. This is useful for understanding what changes will be applied to your Kubernetes resources before actually applying them.

6. `Account ID`, `Activation Token`, `Monitoring Token`. To be received by the Superstream team.

7. Clone this repo

# Deployed pods
- 2 Superstream data planes
- 3 NATS brokers
- 1 Superstream syslog adapter
- 1 telegraf agent for monitoring

# System Requirments 

To ensure optimal performance and stability of the application within a Kubernetes environment, the following system requirements and deployment guidelines must be met:

Hardware Requirements:
 - `CPU`: Minimum of 4 CPU cores.
 - `RAM`: Minimum of 4 GB.
Allocating sufficient resources is crucial to meet or exceed these specifications for the application to function as intended within a Kubernetes pod.

Deployment Restrictions:
Cloud Instances: The application must be deployed on dedicated or reserved instances within the Kubernetes cluster. It `cannot run on spot instances` due to the potential for unexpected termination, which could disrupt the service.

# Getting started
Before deploying with helmfile, you need to configure your environment settings and any specific parameters required for your deployment.
Follow these steps to set up your configuration:

## 1. Configure Environment Tokens
Open the `environments/default.yaml` file in your preferred text editor. 
Add or update the necessary parameters to match your deployment requirements.

## 2. *Optional.* Configure Kafka Connections (Can take place through the GUI)
Every data plane is capable of establishing connections with one or several Kafka clusters simultaneously. 
To determine the optimal strategy for your setup, it is advisable to seek guidance from the Superstream team.

Kafka clusters should be defined in the `config.yaml` file:

```yaml
connections:
  - name: <connection_name>
    type: <connection_type> # available types : confluent_kafka, confluent_cloud_kafka, MSK, apache_kafka
    hosts: # list of bootstrap servers
      - <bootstrap_server_1>
      - <bootstrap_server_2>
    authentication: # Specify one preferred method for connection
      method:
        noAuthentication:
          enabled: <true_or_false>
        ssl:
          enabled: <true_or_false>
          protocol: SSL
          ca: "<path_to_ca_cert>"
          cert: "<path_to_cert>"
          key: "<path_to_key>"
          insecureSkipVerify: <true_or_false>
        sasl:
          enabled: <true_or_false>
          mechanism: <sasl_mechanism> # available options: "PLAIN", "SCRAM-SHA-512"
          protocol: SASL_SSL
          username: "<username>"
          password: "<password>"
          tls:
            enabled: <true_or_false>
            ca: "<path_to_ca_cert>"
            cert: "<path_to_cert>"
            key: "<path_to_key>"
            insecureSkipVerify: <true_or_false>
```

- `name`: A unique name for the connection to be displayed through Superstream GUI.
- `type`: The type of Kafka. Options include `confluent_kafka`, `confluent_cloud_kafka`, `MSK`, and `apache_kafka`.
- `hosts`: A list of bootstrap servers for the Kafka cluster.

**Authentication:**

- `noAuthentication`: Set `enabled` to `true` if no authentication is required.
- `ssl`: For SSL encryption without SASL authentication.
  - `enabled`: Set to `true` to enable SSL authentication.
  - `protocol`: Should always be `SSL`.
  - `ca`, `cert`, `key`: Paths to your CA certificate, client certificate, and client key files.
  - `insecureSkipVerify`: Set to `true` to bypass server certificate verification (not recommended for production environments).
- `sasl`: For SASL authentication.
  - `enabled`: Set to `true` to enable SASL authentication.
  - `mechanism`: The SASL mechanism to use. Options: `PLAIN`, `SCRAM-SHA-512`.
  - `protocol`: Should be `SASL_SSL` for encrypted connections.
  - `username` and `password`: Credentials for SASL authentication.
  - `tls`: Optional TLS configuration for SASL authentication.

#### TLS Configuration for SASL

If TLS is used with SASL, specify the following:
- `enabled`: Set to `true` to enable TLS.
- `ca`, `cert`, `key`: Paths to your CA certificate, client certificate, and client key files, if required.
- `insecureSkipVerify`: Set to `true` to bypass server certificate verification (not recommended for production environments).

### Example

Below is an example configuration for a SASL_SSL authenticated connection:

```yaml
connections:
  - name: my_kafka_connection
    type: confluent_cloud_kafka
    hosts:
      - kafka.example.com:9092
    authentication:
      method:
        sasl:
          enabled: true
          mechanism: PLAIN
          protocol: SASL_SSL
          username: "myUsername"
          password: "myPassword"
          tls:
            enabled: false
```

Replace placeholders (e.g., `<connection_name>`, `<bootstrap_server_1>`) with your actual Kafka connection details. Make sure to follow the correct indentation and formatting as shown in the examples.

For any questions or further assistance, please refer to the official Kafka documentation or reach out to your Kafka provider.
## 3. Deploy using Helmfile
To apply the Helmfile configurations and deploy your Kubernetes resources, follow these steps:

1. Navigate to the Helmfile Directory (where helmfile is stored):
2. Apply Helmfile:
Run the following command to apply the Helmfile configuration. This will sync your Helm releases to match the state declared in your helmfile.yaml.
``` bash
helmfile -e default apply
```
The `-e default` flag specifies the environment. You can adjust this according to your Helmfile's environment configurations.
3. Verify Deployment:
After applying the Helmfile, you can verify the deployment by listing the Helm releases:
```bash
helm list
```

# Appendix A - Cluster Role Configuration

## In case a data plane deployed twice or more on the same K8S cluster

### Edit the following parameter `rbacClusterWide` in the environment section of the helmfile.yaml file
```yaml
environments:
  default:
    values:
    - ./environments/default.yaml
    - rbacCreate: true 
    - rbacClusterWide: true
```

### Update `telegraf` Cluster Role Binding with the additional namespace. Add the following to the `subjects` section. (edit namespace variable)
```yaml
subjects:
  - kind: ServiceAccount
    name: telegraf
    namespace: superstream-new-namespace
```

# Appendix B - Non-HA Deployment

## For testing purposes only Superstream can be deployed without HA capabilities

### Change to `false` the following parameter `haDeployment` in the environment section of the helmfile.yaml file
```yaml
environments:
  default:
    values:
    - ./environments/default.yaml
    - haDeployment: false
```

# Appendix C - Superstream Update

## Minor update

### To update the Superstream Data Plane version, run the following steps.

1. Retrieve the Most Recent Version of the Superstream Helm Chart

```bash
helm search repo superstream/superstream --versions | sort -r | head -n 1
```

2. Modify the `helmVersion` value in the `environments/default.yaml` file.

3. To update your Helm releases in accordance with the state outlined in your `helmfile.yaml`, run the command below. This synchronizes your deployments to the latest configurations:
   
``` bash
helmfile -e default apply
``` 

## Major update

### The first step involves backing up your current `default.yaml` file. Following this, update your repository by pulling the latest changes from the master branch. Once updated, merge your backup values into the environments/default.yaml file. Continue with the process by following these instructions:

1. Backup the `defualt.yaml` file:
   
```bash
cp environments/default.yaml environments/default.yaml.bkp
```

2. Pull the latest updates from the repository master branch

```bash
git stash
git pull
```

3. Edit the new version of the `default.yaml` file according to the previous backup.

4. Check the Pending Changes:

```bash
helmfile -e default diff
```

5. Implement the updates to your Helm releases to match the latest helmfile.yaml configuration, ensuring your deployments are updated to the newest settings, by running:
   
``` bash
helmfile -e default apply
``` 

# Appendix D - Uninstall

## Steps to Uninstall Superstream Data Plane Deployment.

1. Delete Superstream Data Plane Helm Releases:
```bash
helmfile -e default destroy
```

2. Remove Persistent Storage Bound to the Data Plane:

It's crucial to delete the stateful storage linked to the data plane. Ensure you carefully specify the namespace in the command below before executing it:

```bash
kubectl delete pvc -l app.kubernetes.io/instance=nats -n <NAMESPACE>
```
