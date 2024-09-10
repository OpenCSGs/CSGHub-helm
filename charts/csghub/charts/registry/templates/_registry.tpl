{{- /*
Copyright OpenCSG, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Define the host of registry
*/}}
{{- define "registry.host" -}}
{{- printf "%s-%s-hl-svc" .Release.Name "registry" -}}
{{- end }}

{{/*
Define the port of registry
*/}}
{{- define "registry.port" -}}
{{- $port := "" }}
{{- if hasKey .Values.global "registry" }}
  {{- if hasKey .Values.global.registry "service" }}
    {{- if hasKey .Values.global.registry.service "port" }}
      {{- $port = .Values.global.registry.service.port }}
    {{- end }}
    {{- if hasKey .Values.global.registry.service "nodePort" }}
      {{- $port = .Values.global.registry.service.nodePort }}
    {{- end }}
  {{- end }}
{{- end }}
{{- $port | default "5000" -}}
{{- end }}

{{/*
Define the endpoint of registry
*/}}
{{- define "registry.endpoint" -}}
{{- $host := include "registry.host" . }}
{{- $port := include "registry.port" . }}
{{- $type := "ClusterIP" }}
{{- if hasKey .Values.global "registry" }}
    {{- if hasKey .Values.global.registry "enabled" }}
        {{- if  .Values.global.registry.enabled }}
          {{- $host = (include "external.domain.registry" .) }}
        {{- end }}
    {{- end }}
    {{- if hasKey .Values.global.registry "service" }}
      {{- if hasKey .Values.global.registry.service "type" }}
        {{- $type = .Values.global.registry.service.type }}
      {{- end }}
    {{- end }}
{{- end }}
{{- if eq "NodePort" $type }}
{{- printf "%s:%s" $host $port -}}
{{- else }}
{{- printf "%s" $host -}}
{{- end }}
{{- end }}

{{/*
Define the secret of registry
*/}}
{{- define "registry.secret" -}}
{{- printf "%s-%s-secret" .Release.Name "registry" -}}
{{- end }}

{{/*
Define the docker secret of registry
*/}}
{{- define "registry.secret.docker" -}}
{{- printf "%s-%s-docker-secret" .Release.Name "registry" -}}
{{- end }}

{{/*
Define the namespace of registry
*/}}
{{- define "registry.namespace" -}}
{{- $namespace := "" }}
{{- if hasKey .Values.global "registry" }}
  {{- if hasKey .Values.global.registry "namespace" }}
    {{- $namespace = .Values.global.registry.namespace }}
  {{- end }}
{{- end }}
{{- $namespace | default "space" -}}
{{- end }}

{{/*
Define the repository of registry
*/}}
{{- define "registry.repository" -}}
{{- if eq "true" (include "registry.enabled" .) }}
{{- printf "%s/%s/" (include "registry.endpoint" .) (include "registry.namespace" .) -}}
{{- else }}
{{- printf "%s/%s/" .Values.global.builder.registry.repository .Values.global.builder.registry.namespace -}}
{{- end }}
{{- end }}