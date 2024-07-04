window._env_ = {
    REACT_APP_API_URL: "{{ .Values.vrtConfig.reactAppApiUrl }}",
    PORT: "{{ .Values.vrtComponents.ui.service.port }}",
    VRT_VERSION: "{{ .Chart.AppVersion }}",
}
