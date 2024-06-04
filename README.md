<div align="center">

<img src="https://github.com/memphisdev/superstream-helmfile/assets/70286779/5921cf13-ce6c-4888-8ed1-e602f7f60383" width="30%"><br><br>
Improve And Optimize Your Kafka In Literally Minutes.<br>
Reduce Costs and Boost Performance by 75% Without Changing a Single Component or Your Existing Kafka!

</div>

## How to deploy

To deploy the helm chart, the variables in the provided custom_values.yaml file should be filled according to the supplied by Superstream values:
```yaml
############################################################
# GLOBAL configuration for Superstream Engine
############################################################
global:
  environment: ""               # Define the superstream engine name within 32 characters, excluding '.', and using only lowercase letters, numbers, '-', and '_'.
  accountId: ""                 # Provide the account ID associated with the deployment, which could be used for identifying resources or configurations tied to a specific account.
  activationToken: ""           # Enter the activation token required for services or resources that need an initial token for activation or authentication.
  skipLocalAuthentication: true

############################################################
# NATS config
############################################################
# NATS HA Deployment. Default "true"
nats:
  config:
    cluster:
      enabled: true
# NATS storageClass configuration. Default is blank "".
    jetstream:
      fileStore:
        pvc:
          storageClassName: ""
```
To deploy it, run the following:
```bash
helm repo add superstream https://k8s.superstream.dev/charts/ --force-update && helm install superstream superstream/superstream -f custom_values.yaml --create-namespace --namespace superstream --wait
```

## Parameters
The following table lists the configurable parameters of the SuperStream chart and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `superstream.environment` | Deployment environment (e.g., staging, production). | `""` |
| `superstream.serviceAccount.create` | Specifies whether a service account should be created. | `true` |
| `superstream.serviceAccount.annotations` | Annotations to add to the service account. | `{}` |
| `superstream.serviceAccount.name` | The name of the service account to use. | `""` |
| `initContainers.image` | Image used for readiness checks or setup tasks. | `curlimages/curl:8.6.0` |
| `dataPlane.releaseDate` | Release date for the backend component. | `"2024-02-22-13-03"` |
| `dataPlane.replicaCount` | Number of replicas for the backend deployment. | `2` |
| `dataPlane.image.repository` | Docker image repository for the backend service. | `memphisos/superstream-data-plane-be` |
| `dataPlane.image.pullPolicy` | Policy for pulling the image. | `Always` |
| `dataPlane.image.tag` | Overrides the image tag. | `"latest"` |
| `dataPlane.imagePullSecrets` | Image pull secrets. | `""` |
| `dataPlane.configMap.enable` | Enable ConfigMap settings. | `""` |
| `dataPlane.secret.name` | Secret configuration for sensitive information. | `superstream-creds` |
| `dataPlane.service.enabled` | Enable service for the backend. | `false` |
| `dataPlane.service.type` | Type of service for the backend. | `ClusterIP` |
| `dataPlane.service.port` | Port for the backend service. | `8888` |
| `dataPlane.ingress.enabled` | Enable ingress for the backend. | `false` |
| `dataPlane.resources.limits.cpu` | CPU limit for the backend pod. | `500m` |
| `dataPlane.resources.limits.memory` | Memory limit for the backend pod. | `500Mi` |
| `dataPlane.resources.requests.cpu` | CPU request for the backend pod. | `50m` |
| `dataPlane.resources.requests.memory` | Memory request for the backend pod. | `100Mi` |
| `dataPlane.autoscaling.enabled` | Enable autoscaling for the backend. | `true` |
| `dataPlane.autoscaling.minReplicas` | Minimum number of replicas for autoscaling. | `2` |
| `dataPlane.autoscaling.maxReplicas` | Maximum number of replicas for autoscaling. | `5` |
| `dataPlane.autoscaling.targetCPUUtilizationPercentage` | CPU utilization percentage for autoscaling. | `75` |
| `dataPlane.autoscaling.targetMemoryUtilizationPercentage` | Memory utilization percentage for autoscaling. | `75` |
| `syslog.replicaCount` | Number of replicas for the syslog deployment. | `1` |
| `syslog.image.repository` | Docker image repository for syslog. | `linuxserver/syslog-ng` |
| `syslog.image.pullPolicy` | Pull policy for the syslog image. | `IfNotPresent` |
| `syslog.image.tag` | Tag for the syslog image. | `"latest"` |
| `syslog.service.type` | Type of service for syslog. | `ClusterIP` |
| `syslog.service.port` | Port for the syslog service. | `5514` |
| `syslog.service.protocol` | Protocol for the syslog service. | `UDP` |
| `syslog.resources.limits.cpu` | CPU limit for the syslog pod. | `"100m"` |
| `syslog.resources.limits.memory` | Memory limit for the syslog pod. | `"256Mi"` |
| `syslog.resources.requests.cpu` | CPU request for the syslog pod. | `"50m"` |
| `syslog.resources.requests.memory` | Memory request for the syslog pod. | `"128Mi"` |
| `syslog.configMap.enabled` | Enable ConfigMap for syslog. | `true` |
| `syslog.configMap.name` | Name of the ConfigMap for syslog. | `syslog-config` |
| `syslog.configMap.mountPath` | Mount path for the syslog ConfigMap. | `/config/syslog-ng.conf` |
| `syslog.configMap.subPath` | Specific file to mount from the ConfigMap. | `syslog-ng.conf` |
| `syslog.persistence.enabled` | Enable persistence for syslog. | `false
