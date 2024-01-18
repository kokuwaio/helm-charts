{{/*
Expand the name of the chart.
*/}}
{{- define "visual-regression-tracker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "visual-regression-tracker.fullname" -}}
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
{{- define "visual-regression-tracker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "visual-regression-tracker.labels" -}}
helm.sh/chart: {{ include "visual-regression-tracker.chart" . }}
{{ include "visual-regression-tracker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "visual-regression-tracker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "visual-regression-tracker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "visual-regression-tracker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "visual-regression-tracker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
elasticsearch secret name
*/}}
{{- define "visual-regression-tracker.elasticsearchSecretName" -}}
{{- if .Values.secrets.elasticsearch.useExisting -}}
{{ .Values.secrets.elasticsearch.secretName }}
{{- else -}}
{{ template "visual-regression-tracker.fullname" . }}-{{ .Values.secrets.elasticsearch.secretName }}
{{- end -}}
{{- end -}}

{{/*
jwt secret name
*/}}
{{- define "visual-regression-tracker.jwtSecretName" -}}
{{- if .Values.secrets.jwt.useExisting -}}
{{ .Values.secrets.jwt.secretName }}
{{- else -}}
{{ template "visual-regression-tracker.fullname" . }}-{{ .Values.secrets.jwt.secretName }}
{{- end -}}
{{- end -}}

{{/*
postgresql secret name
*/}}
{{- define "visual-regression-tracker.postgresqlSecretName" -}}
{{- if .Values.secrets.postgresql.useExisting -}}
{{ .Values.secrets.postgresql.secretName }}
{{- else -}}
{{ template "visual-regression-tracker.fullname" . }}-{{ .Values.secrets.postgresql.secretName }}
{{- end -}}
{{- end -}}

{{/*
vrt secret name
*/}}
{{- define "visual-regression-tracker.vrtSecretName" -}}
{{- if .Values.secrets.defaults.useExisting -}}
{{ .Values.secrets.defaults.secretName }}
{{- else -}}
{{ template "visual-regression-tracker.fullname" . }}-{{ .Values.secrets.defaults.secretName }}
{{- end -}}
{{- end -}}
