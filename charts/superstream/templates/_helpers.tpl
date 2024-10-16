{{/*
Expand the name of the chart.
*/}}
{{- define "superstream.name" -}}
{{- default .Chart.Name .Values.superstreamEngine.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "superstream.namespace" -}}
{{- default .Release.Namespace .Values.superstreamEngine.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "superstream.fullname" -}}
{{- if .Values.superstreamEngine.fullnameOverride }}
{{- .Values.superstreamEngine.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.superstreamEngine.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "superstream.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "superstream.labels" -}}
{{- with .Values.global.labels -}}
{{ toYaml . }}
{{ end -}}
helm.sh/chart: {{ include "superstream.chart" . }}
{{ include "superstream.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "superstream.selectorLabels" -}}
app.kubernetes.io/name: {{ include "superstream.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "superstream.secret" -}}
{{- if not .Values.superstreamEngine.secret.useExisting -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace .Values.superstreamEngine.secret.name -}}
{{- if $secret -}}
{{ toYaml $secret.data }}
{{- else -}}
ENCRYPTION_SECRET_KEY: {{ randAlphaNum 32 | b64enc | quote }}
ACTIVATION_TOKEN: {{ .Values.global.superstreamActivationToken | toString | b64enc | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "superstream.serviceAccountName" -}}
{{- if .Values.superstreamEngine.serviceAccount.create }}
{{- default (include "superstream.fullname" .) .Values.superstreamEngine.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.superstreamEngine.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Print the image
*/}}
{{- define "superstream.image" }}
{{- $image := printf "%s:%s" .repository .tag }}
{{- if or .registry .global.image.registry }}
{{- $image = printf "%s/%s" (.registry | default .global.image.registry) $image }}
{{- end -}}
image: {{ $image }}
{{- if or .pullPolicy .global.image.pullPolicy }}
imagePullPolicy: {{ .pullPolicy | default .global.image.pullPolicy }}
{{- end }}
{{- end }}

{{- define "superstream.podSecurityContext" -}}
{{- if or .podSecurityContext .global.podSecurityContext -}}
{{ toYaml (.podSecurityContext | default .global.podSecurityContext) | nindent 4 -}}
{{- end }}
{{- end }}