{{- if .Values.podAnnotations }}
metadata:
  annotations:
{{ toYaml .Values.podAnnotations | indent 4 }}
{{- end }}
spec:
  {{- with .Values.imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.securityContext.enabled }}
  securityContext:
    fsGroup: {{ .Values.securityContext.fsGroup }}
    runAsUser: {{ .Values.securityContext.runAsUser }}
  {{- end }}
  containers:
  - name: mysql-backup
    image: "{{ .Values.image.registry }}/{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
    command: ["/bin/bash", "/scripts/backup.sh"]
{{- if or .Values.mysql.existingSecret .Values.upload.openstack.existingSecret }}
    env:
{{- end }}
{{- if .Values.mysql.existingSecret }}
      - name: MYSQL_PWD
        valueFrom:
          secretKeyRef:
            name: {{ .Values.mysql.existingSecret | quote }}
            {{- if .Values.mysql.existingSecretKey }}
            key: {{ .Values.mysql.existingSecretKey | quote }}
            {{- else }}
            key: "mysql-root-password"
            {{- end }}
{{- end }}
{{- if .Values.upload.openstack.existingSecret }}
      - name: OS_PASSWORD
        valueFrom:
          secretKeyRef:
            name: {{ .Values.upload.openstack.existingSecret | quote }}
            {{- if .Values.upload.openstack.existingSecretKey }}
            key: {{ .Values.upload.openstack.existingSecretKey | quote }}
            {{- else }}
            key: "openstack-backup-password"
            {{- end }}
{{- end }}
    envFrom:
    - configMapRef:
        name: "{{ template "mysqldump.fullname" . }}"
{{- if not .Values.mysql.existingSecret }}
    - secretRef:
        name: "{{ template "mysqldump.fullname" . }}"
{{- end }}
    volumeMounts:
    - name: backups
      mountPath: /backup
{{- if .Values.persistence.subPath }}
      subPath: {{ .Values.persistence.subPath }}
{{- end }}
    - name: mysql-backup-script
      mountPath: /scripts
{{- if .Values.upload.ssh.enabled }}
    - name: ssh-privatekey
      mountPath: {{ .Values.sshMountpath }}/.ssh
{{- end }}
{{- if .Values.upload.googlestoragebucket.enabled }}
    - name: gcloud-keyfile
      mountPath: {{ .Values.sshMountpath }}/gcloud
{{- end }}
    resources: 
{{ toYaml .Values.resources | indent 6 }}
{{- with .Values.nodeSelector }}
  nodeSelector:
{{ toYaml . | indent 4 }}
{{- end }}
{{- with .Values.affinity }}
  affinity:
{{ toYaml . | indent 4 }}
{{- end }}
{{- with .Values.tolerations }}
  tolerations:
{{ toYaml . | indent 4 }}
{{- end }}
  restartPolicy: Never
  volumes:
  - name: backups
{{- if .Values.persistentVolumeClaim }}
    persistentVolumeClaim:
      claimName: {{ .Values.persistentVolumeClaim }}
{{- else -}}
{{- if .Values.persistence.enabled }}
    persistentVolumeClaim:
      claimName: {{ template "mysqldump.fullname" . }}
{{- else }}
    emptyDir: {}
{{- end }}
{{- end }}
  - name: mysql-backup-script
    configMap:
      name: {{ template "mysqldump.fullname" . }}-script
{{- if .Values.upload.ssh.enabled }}
  - name: ssh-privatekey
    secret:
      secretName: {{ if .Values.upload.ssh.existingSecret }}{{ .Values.upload.ssh.existingSecret }}{{ else }}{{ template "mysqldump.fullname" . }}-ssh-privatekey{{ end }}
      defaultMode: 256
{{- end }}
{{- if .Values.upload.googlestoragebucket.enabled }}
  - name: gcloud-keyfile
    secret:
      secretName: {{ if .Values.upload.googlestoragebucket.existingSecret }}{{ .Values.upload.googlestoragebucket.existingSecret }}{{ else }}{{ template "mysqldump.gcpsecretName" . }}{{ end }}
      defaultMode: 256
{{ end }}
