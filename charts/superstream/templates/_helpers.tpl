{{/*
Expand the name of the chart.
*/}}
{{- define "superstream.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "superstream.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "superstream.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
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
{{- $secret := lookup "v1" "Secret" .Release.Namespace .Values.superstreamEngine.secret.name -}}
{{- if $secret -}}
{{ toYaml $secret.data }}
{{- else -}}
ENCRYPTION_SECRET_KEY: {{ randAlphaNum 32 | b64enc | quote }}
ACTIVATION_TOKEN: {{ .Values.global.activationToken | toString | b64enc | quote }}
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