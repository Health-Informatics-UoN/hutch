{{/*
Expand the name of the chart.
*/}}
{{- define "hutch.relay.name" -}}
{{- default "relay" .Values.relay.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "hutch.bunny.name" -}}
{{- default "bunny" .Values.bunny.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified buny app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hutch.bunny.fullname" -}}
{{- if .Values.bunny.fullnameOverride }}
{{- .Values.bunny.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := include "hutch.bunny.name" . }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified buny app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hutch.relay.fullname" -}}
{{- if .Values.relay.fullnameOverride }}
{{- .Values.relay.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := include "hutch.relay.name" . }}
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
{{- define "hutch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hutch.bunny.labels" -}}
helm.sh/chart: {{ include "hutch.chart" . }}
{{ include "hutch.bunny.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hutch.bunny.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hutch.bunny.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hutch.relay.labels" -}}
helm.sh/chart: {{ include "hutch.chart" . }}
{{ include "hutch.relay.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hutch.relay.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hutch.relay.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hutch.bunny.serviceAccountName" -}}
{{- if .Values.bunny.serviceAccount.create }}
{{- default (include "hutch.bunny.fullname" .) .Values.bunny.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.bunny.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hutch.relay.serviceAccountName" -}}
{{- if .Values.relay.serviceAccount.create }}
{{- default (include "hutch.relay.fullname" .) .Values.relay.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.relay.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "hutch.bunny.env.defaults" -}}
{{- list 
  (dict "name" "TASK_API_TYPE" "value" "")
  (dict "name" "LOW_NUMBER_SUPPRESSION_THRESHOLD" "value" "")
  (dict "name" "ROUNDING_TARGET" "value" "")
  (dict "name" "POLLING_INTERVAL" "value" "5")
  (dict "name" "COLLECTION_ID" "value" "collection_id")
  | toYaml
-}}
{{- end -}}



{{- define "hutch.bunny.secrets.db" -}}
{{- if (((.Values.global).postgresql).auth).postgresPassword }}
password: {{ .Values.global.postgresql.auth.postgresPassword }}
{{- else if (((.Values.global).postgresql).auth).password }}
password: {{ .Values.global.postgresql.auth.password }}
{{- else if ((.Values.postgresql).auth).postgresPassword }}
password: {{ .Values.postgresql.auth.postgresPassword }}
{{- else if ((.Values.postgresql).auth).password }}
password: {{ .Values.postgresql.auth.password }}
{{- else }}
password: {{ required "Missing postgresql password for bunny" .Values.bunny.db.auth.password }}
{{- end -}}

{{- if (((.Values.global).postgresql).auth).username }}
username: {{ .Values.global.postgresql.auth.username }}
{{- else if ((.Values.postgresql).auth).username }}
username: {{ .Values.postgresql.auth.username }}
{{- else }}
username: {{ required "Missing postgresql username for bunny" .Values.bunny.db.auth.username }}
{{- end -}}
{{- end -}}



{{- define "hutch.bunny.env.db" -}}
{{- $envVars := list }}

{{- if .Values.bunny.db.auth.existingSecretKey }}
  {{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_USERNAME" "valueFrom" (dict "secretKeyRef" (dict "name" .Values.bunny.db.auth.existingSecretName "key" .Values.bunny.db.auth.existingSecretUsernameKey))) }}
  {{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_PASSWORD" "valueFrom" (dict "secretKeyRef" (dict "name" .Values.bunny.db.auth.existingSecretName "key" .Values.bunny.db.auth.existingSecretPasswordKey))) }}
{{- else }}
  {{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_USERNAME" "valueFrom" (dict "secretKeyRef" (dict "name" (include "hutch.bunny.name" .) "key" "db_username"))) }}
  {{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_PASSWORD" "valueFrom" (dict "secretKeyRef" (dict "name" (include "hutch.bunny.name" .) "key" "db_password"))) }}
{{- end }}

{{- if .Values.postgresql.enabled -}}
{{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_DRIVERNAME" "value" "postgresql") }}
{{- else -}}
{{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_DRIVERNAME" "value" .Values.bunny.db.driverName) }}
{{- end -}}

{{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_DATABASE" "value" .Values.bunny.db.dbName) }}
{{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_SCHEMA" "value" .Values.bunny.db.schema) }}
{{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_PORT" "value" (printf "%d" (int .Values.bunny.db.port))) }}

{{- if .Values.postgresql.enabled -}}
{{- $pgHost := printf "%s-%s.%s.svc.cluster.local" .Release.Name "postgresql" .Release.Namespace -}}
{{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_HOST" "value" $pgHost) }}
{{- else -}}
{{- $envVars = append $envVars (dict "name" "DATASOURCE_DB_HOST" "value" .Values.bunny.db.host) }}
{{- end -}}

{{- toYaml $envVars }}
{{- end -}}

{{- define "hutch.bunny.env.taskApi" -}}
{{- $envVars := list }}
{{- if .Values.bunny.taskApi.basicAuth.existingSecretKey }}
  {{- $envVars = append $envVars (dict "name" "TASK_API_USERNAME" "valueFrom" (dict "secretKeyRef" (dict "name" .Values.bunny.taskApi.basicAuth.existingSecretName "key" .Values.bunny.taskApi.basicAuth.existingSecretUsernameKey))) }}
  {{- $envVars = append $envVars (dict "name" "TASK_API_PASSWORD" "valueFrom" (dict "secretKeyRef" (dict "name" .Values.bunny.taskApi.basicAuth.existingSecretName "key" .Values.bunny.taskApi.basicAuth.existingSecretPasswordKey))) }}
{{- else }}
  {{- $envVars = append $envVars (dict "name" "TASK_API_USERNAME" "valueFrom" (dict "secretKeyRef" (dict "name" (include "hutch.bunny.name" .) "key" "task_api_username"))) }}
  {{- $envVars = append $envVars (dict "name" "TASK_API_PASSWORD" "valueFrom" (dict "secretKeyRef" (dict "name" (include "hutch.bunny.name" .) "key" "task_api_password"))) }}
{{- end }}

{{- if .Values.relay.enabled -}}
{{- $envVars = append $envVars (dict "name" "TASK_API_BASE_URL" "value" (printf "http://%s.%s.svc.cluster.local:%d" (include "hutch.relay.fullname" .) .Release.Namespace (int .Values.relay.service.port))) }}
{{- else -}}
{{- $envVars = append $envVars (dict "name" "TASK_API_BASE_URL" "value" (.Values.bunny.taskApi.baseUrl | required "The bunny.taskApi.baseUrl is required")) }}
{{- end -}}

{{- toYaml $envVars }}
{{- end -}}

{{- define "hutch.bunny.env" -}}
{{- $defaults := include "hutch.bunny.env.defaults" . | fromYamlArray -}}
{{- $db := include "hutch.bunny.env.db" . | fromYamlArray -}}
{{- $taskApi := include "hutch.bunny.env.taskApi" . | fromYamlArray -}}
{{- $extra := .Values.bunny.extraEnvVars | default list -}}
{{- $listOfLists := list $defaults $db $taskApi $extra -}}
{{- $merged := dict -}}
{{- /* Load defaults into merged dict */ -}}
{{- range $listOfLists }}
  {{- range . }}
    {{- $_ := set $merged .name . }}
  {{- end }}
{{- end }}
{{- /* Convert merged dict back into a list */ -}}
{{- $mergedList := list }}
{{- range $merged }}
  {{- $mergedList = append $mergedList . }}
{{- end }}
{{- toYaml $mergedList | nindent 0 }}
{{- end -}}

{{- define "hutch.relay.secrets.db" -}}
{{- if (((.Values.global).postgresql).auth).postgresPassword }}
password: {{ .Values.global.postgresql.auth.postgresPassword }}
{{- else if (((.Values.global).postgresql).auth).password }}
password: {{ .Values.global.postgresql.auth.password }}
{{- else if ((.Values.postgresql).auth).postgresPassword }}
password: {{ .Values.postgresql.auth.postgresPassword }}
{{- else if ((.Values.postgresql).auth).password }}
password: {{ .Values.postgresql.auth.password }}
{{- else }}
password: {{ required "Missing postgresql password for relay" .Values.relay.db.auth.password }}
{{- end -}}

{{- if (((.Values.global).postgresql).auth).username }}
username: {{ .Values.global.postgresql.auth.username }}
{{- else if ((.Values.postgresql).auth).username }}
username: {{ .Values.postgresql.auth.username }}
{{- else }}
username: {{ required "Missing postgresql username for relay" .Values.relay.db.auth.username }}
{{- end -}}

{{- /* TODO: support postgresql chart settings */ -}}
{{- if .Values.postgresql.enabled }}
host: {{ printf "%s-%s.%s.svc.cluster.local" .Release.Name "postgresql" .Release.Namespace }}
{{- else }}
host: {{ required "Must define the relay postgresql host or set postgresql.enabled to true" .Values.relay.db.host }}
{{- end }}

port: {{ required "Must define the relay postgresql port" .Values.relay.db.port }}

database: {{ required "Must define the relay postgresql database name" .Values.relay.db.dbName }}
{{- end -}}


{{- define "hutch.relay.secrets.rabbitmq" -}}
{{- if .Values.rabbitmq.enabled -}}
  {{- if (.Values.rabbitmq.auth).username }}
username: {{ .Values.rabbitmq.auth.username }}
  {{- else }}
username: {{ required "Missing rabbitmq username for relay" .Values.relay.queue.auth.username }}
  {{- end }}
{{- else }}
username: {{ required "Missing rabbitmq username for relay" .Values.relay.queue.auth.username }}
{{- end -}}

{{- if .Values.rabbitmq.enabled -}}
  {{- if (.Values.rabbitmq.auth).password }}
password: {{ .Values.rabbitmq.auth.password }}
  {{- else }}
password: {{ required "Missing rabbitmq password for relay" .Values.relay.queue.auth.password }}
  {{- end }}
{{- else }}
password: {{ required "Missing rabbitmq password for relay" .Values.relay.queue.auth.password }}
{{- end -}}

{{- /* TODO: support postgresql chart settings */ -}}
{{- if .Values.rabbitmq.enabled }}
host: {{ printf "%s-%s.%s.svc.cluster.local" .Release.Name "rabbitmq" .Release.Namespace }}
{{- else }}
host: {{ required "Must define the relay rabbitmq host or set rabbitmq.enabled to true" .Values.relay.queue.host }}
{{- end }}

port: {{ required "Must define the relay rabbitmq port" .Values.relay.queue.port }}
{{- end -}}


{{- define "hutch.relay.env.defaults" -}}
{{- list 
  (dict "name" "DOTNET_Environment" "value" "Development")
  (dict "name" "Obfuscation__LowNumberSuppressionThreshold" "value" "0")
  (dict "name" "Obfuscation__RoundingTarget" "value" "0")
  (dict "name" "Database__ApplyMigrationsOnStartup" "value" "true")
  | toYaml
-}}
{{- end -}}


{{- define "hutch.relay.env.db" -}}
{{- $envVars := list }}

{{- if .Values.relay.db.auth.existingSecretKey }}
  {{- $envVars = append $envVars (dict "name" "ConnectionStrings__Default" "valueFrom" (dict "secretKeyRef" (dict "name" .Values.relay.db.auth.existingSecretName "key" .Values.relay.db.auth.existingSecretDbConnectionStringKey))) }}
{{- else }}
  {{- $envVars = append $envVars (dict "name" "ConnectionStrings__Default" "valueFrom" (dict "secretKeyRef" (dict "name" (include "hutch.relay.name" .) "key" "db_connection_string"))) }}
{{- end }}

{{- toYaml $envVars }}
{{- end -}}


{{- define "hutch.relay.env.rabbitmq" -}}
{{- $envVars := list }}

{{- if .Values.relay.queue.auth.existingSecretKey }}
  {{- $envVars = append $envVars (dict "name" "RelayTaskQueue__ConnectionString" "valueFrom" (dict "secretKeyRef" (dict "name" .Values.relay.queue.auth.existingSecretName "key" .Values.relay.queue.auth.existingSecretRabbitMqConnectionStringKey))) }}
{{- else }}
  {{- $envVars = append $envVars (dict "name" "RelayTaskQueue__ConnectionString" "valueFrom" (dict "secretKeyRef" (dict "name" (include "hutch.relay.name" .) "key" "rabbitmq_connection_string"))) }}
{{- end }}

{{- toYaml $envVars }}
{{- end -}}


{{- define "hutch.relay.env.upstreamTaskApi" -}}
{{- $envVars := list }}

{{- if .Values.relay.upstreamTaskApi.basicAuth.existingSecretKey }}
  {{- $envVars = append $envVars (dict "name" "UpstreamTaskApi__Username" "valueFrom" (dict "secretKeyRef" (dict "name" .Values.relay.upstreamTaskApi.basicAuth.existingSecretName "key" .Values.relay.upstreamTaskApi.basicAuth.existingSecretUsernameKey))) }}
  {{- $envVars = append $envVars (dict "name" "UpstreamTaskApi__Password" "valueFrom" (dict "secretKeyRef" (dict "name" .Values.relay.upstreamTaskApi.basicAuth.existingSecretName "key" .Values.relay.upstreamTaskApi.basicAuth.existingSecretPasswordKey))) }}
{{- else }}
  {{- $envVars = append $envVars (dict "name" "UpstreamTaskApi__Username" "valueFrom" (dict "secretKeyRef" (dict "name" (include "hutch.relay.name" .) "key" "upstream_task_api_username"))) }}
  {{- $envVars = append $envVars (dict "name" "UpstreamTaskApi__Password" "valueFrom" (dict "secretKeyRef" (dict "name" (include "hutch.relay.name" .) "key" "upstream_task_api_password"))) }}
{{- end }}

{{- $envVars = append $envVars (dict "name" "UpstreamTaskApi__BaseUrl" "value" (required "relay.upstreamTaskApi.baseUrl is required" .Values.relay.upstreamTaskApi.baseUrl)) }}
{{- $envVars = append $envVars (dict "name" "UpstreamTaskApi__CollectionId" "value" (required "relay.upstreamTaskApi.collectionId is required" .Values.relay.upstreamTaskApi.collectionId)) }}

{{- toYaml $envVars }}
{{- end -}}


{{- define "hutch.relay.env" -}}
{{- $defaults := include "hutch.relay.env.defaults" . | fromYamlArray -}}
{{- $db := include "hutch.relay.env.db" . | fromYamlArray -}}
{{- $rabbitmq := include "hutch.relay.env.rabbitmq" . | fromYamlArray -}}
{{- $upstreamTaskApi := include "hutch.relay.env.upstreamTaskApi" . | fromYamlArray -}}
{{- $extra := .Values.relay.extraEnvVars | default list -}}
{{- $listOfLists := list $defaults $db $rabbitmq $upstreamTaskApi $extra -}}
{{- $merged := dict -}}
{{- /* Load defaults into merged dict */ -}}
{{- range $listOfLists }}
  {{- range . }}
    {{- $_ := set $merged .name . }}
  {{- end }}
{{- end }}
{{- /* Convert merged dict back into a list */ -}}
{{- $mergedList := list }}
{{- range $merged }}
  {{- $mergedList = append $mergedList . }}
{{- end }}
{{- toYaml $mergedList | nindent 0 }}
{{- end -}}



{{/*
Return the proper Docker Image Registry Secret Names for Bunny
{{ include "hutch.bunny.imagePullSecrets" . }}
*/}}
{{- define "hutch.bunny.imagePullSecrets" -}}
  {{- $pullSecrets := list }}
  {{- $bunnyPullSecrets := .Values.bunny.imagePullSecrets -}}

  {{- range ((.Values.global).imagePullSecrets) -}}
    {{- if kindIs "map" . -}}
      {{- $pullSecrets = append $pullSecrets .name -}}
    {{- else -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end }}
  {{- end -}}

  {{- range $bunnyPullSecrets -}}
    {{- if kindIs "map" . -}}
      {{- $pullSecrets = append $pullSecrets .name -}}
    {{- else -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- if (not (empty $pullSecrets)) -}}
imagePullSecrets:
    {{- range $pullSecrets | uniq }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names for Relay
{{ include "hutch.relay.imagePullSecrets" . }}
*/}}
{{- define "hutch.relay.imagePullSecrets" -}}
  {{- $pullSecrets := list -}}
  {{- $bunnyPullSecrets := .Values.relay.imagePullSecrets -}}

  {{- range ((.Values.global).imagePullSecrets) -}}
    {{- if kindIs "map" . -}}
      {{- $pullSecrets = append $pullSecrets .name -}}
    {{- else -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end }}
  {{- end -}}

  {{- range $bunnyPullSecrets -}}
    {{- if kindIs "map" . -}}
      {{- $pullSecrets = append $pullSecrets .name -}}
    {{- else -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- if (not (empty $pullSecrets)) -}}
imagePullSecrets:
    {{- range $pullSecrets | uniq }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}