{{- define "meu-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "meu-app.fullname" -}}
{{- printf "%s-%s" (include "meu-app.name" .) .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
