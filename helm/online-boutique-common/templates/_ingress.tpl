{{- define "common.ingress" -}}
{{- $ingress := .Values.global.ingress -}}
{{- if $ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $ingress.name | default (printf "%s-ingress" .Values.appName) }}
  annotations:
    kubernetes.io/ingress.class: {{ $ingress.className | default "alb" }}
    alb.ingress.kubernetes.io/scheme: {{ $ingress.scheme | default "internet-facing" }}
    alb.ingress.kubernetes.io/target-type: {{ $ingress.targetType | default "ip" }}
    {{- if $ingress.certificateArn }}
    alb.ingress.kubernetes.io/certificate-arn: {{ $ingress.certificateArn }}
    {{- end }}
    alb.ingress.kubernetes.io/listen-ports: {{ $ingress.listenPorts | default '[{"HTTP": 80}, {"HTTPS": 443}]' }}
    {{- if $ingress.sslRedirect }}
    alb.ingress.kubernetes.io/ssl-redirect: {{ $ingress.sslRedirect }}
    {{- end }}
    {{- if $ingress.groupName }}
    alb.ingress.kubernetes.io/group.name: {{ $ingress.groupName }}
    {{- end }}
spec:
  ingressClassName: {{ $ingress.className | default "alb" }}
  rules:
    - host: {{ $ingress.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ $ingress.backend.serviceName | default .Values.serviceName }}
                port:
                  number: {{ $ingress.backend.portNumber | default 80 }}
{{- end }}
{{- end }}
