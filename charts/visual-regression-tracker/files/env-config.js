window._env_ = {
    REACT_APP_API_URL: "{{ .Values.vrtConfig.reactAppApi.protocol }}://{{ .Values.authProxy.basicAuth.username }}:{{ .Values.authProxy.basicAuth.password }}@{{ .Values.vrtConfig.reactAppApi.url }}",
    PORT: "{{ .Values.vrtComponents.ui.service.port }}",
    VRT_VERSION: "{{ .Chart.AppVersion }}",
}
