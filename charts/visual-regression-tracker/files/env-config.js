window._env_ = {
    REACT_APP_API_URL: "{{ .Values.vrtConfig.reactAppApiUrl }}",
    REACT_APP_STATIC_URL: "{{ .Values.vrtConfig.reactAppStaticUrl }}",
    REACT_APP_OIDC_AUTO_REDIRECT: "{{ .Values.vrtConfig.reactAppOidcAutoRedirect }}",
    PORT: "{{ .Values.vrtComponents.ui.service.port }}",
    VRT_VERSION: "{{ .Chart.AppVersion }}",
}
