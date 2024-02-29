# Helmfile Deployment for Superstream
##### This README provides guidance on how to deploy and manage Superstream microservies on Kubernetes platform.

## Prerequisites
Before you begin, ensure you have the following prerequisites installed and configured:

1. Kubernetes Cluster: You need an up-and-running Kubernetes cluster. If you don't have one, you can create a cluster on platforms like Google Kubernetes Engine (GKE), Amazon EKS, Azure AKS, or Minikube for local development.

2. [kubectl](https://kubernetes.io/docs/tasks/tools/): The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters. Install kubectl if you haven't already.

3. [Helm](https://helm.sh/docs/intro/install/): Helm is a package manager for Kubernetes that facilitates the deployment and management of applications. Install Helm if it's not already set up.

4. [Helmfile](https://helmfile.readthedocs.io/en/latest/#installation): Helmfile is a declarative spec for deploying helm charts. It lets you keep descriptions of your desired state of Helm charts in a versioned YAML file. Install Helmfile if you haven't.

5. [helm-diff plugin](https://github.com/databus23/helm-diff#install) plugin shows a diff explaining what a `helm upgrade` would change. This is useful for understanding what changes will be applied to your Kubernetes resources before actually applying them.

6. This guide assumes that the repository has been cloned and that the installation commands are run from its root directory

# Configuration
Before deploying with helmfile, you need to configure your environment settings and any specific parameters required for your deployment. Follow these steps to set up your configuration:
## Configure Environment Tokens
Open the `environments/default.yaml` file in your preferred text editor. Add or update the necessary parameters to match your deployment requirements.

## Configure Kafka Connections Configuration File
This guide provides detailed instructions on how to configure Kafka connections for the Superstream's data-plane. Our YAML configuration file supports multiple types of Kafka connections, including Confluent Kafka, Confluent Cloud Kafka, Amazon MSK, and Apache Kafka. Follow the steps below to correctly set up your YAML configuration file.

### Configuration Format

The configuration should be defined in a YAML file as follows:

```yaml
connections:
  - name: <connection_name>
    type: <connection_type> # available types : confluent_kafka, confluent_cloud_kafka, MSK, apache_kafka
    hosts: # list of bootstrap servers
      - <bootstrap_server_1>
      - <bootstrap_server_2>
    authentication: # Specify one prefered method for connection
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

### Configuration Details

- `name`: A unique name for the connection.
- `type`: The type of Kafka connection. Options include `confluent_kafka`, `confluent_cloud_kafka`, `MSK`, and `apache_kafka`.
- `hosts`: A list of bootstrap servers for the Kafka cluster.

### Authentication

Specify one preferred method for connection under `authentication`:

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

## Example

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
