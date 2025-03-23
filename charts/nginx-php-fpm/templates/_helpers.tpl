{{/*
Expand the name of the chart.
*/}}
{{- define "nginx-php-fpm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nginx-php-fpm.fullname" -}}
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
{{- define "nginx-php-fpm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels nginx
*/}}
{{- define "nginx-php-fpm-nginx.labels" -}}
helm.sh/chart: {{ include "nginx-php-fpm.chart" . }}
{{ include "nginx-php-fpm-nginx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nginx-php-fpm.labels" -}}
helm.sh/chart: {{ include "nginx-php-fpm.chart" . }}
{{ include "nginx-php-fpm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nginx-php-fpm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx-php-fpm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nginx-php-fpm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nginx-php-fpm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

# create nginx and php version from appVersion: "nginx-alpine3.21-php-8.4.5-fpm"
{{- define "nginx-php-fpm.nginxVersion" -}}
{{-  mustRegexReplaceAll "(nginx-)(.*)(-php-.*)" .Chart.AppVersion "${2}" }}
{{- end }}

{{- define "nginx-php-fpm.phpVersion" -}}
{{- regexReplaceAll "(nginx-.*-)(php-)(.*)" .Chart.AppVersion "${3}" }}
{{- end }}
