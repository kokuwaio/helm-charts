window._env_ = {
  REACT_APP_API_URL:
    '{{ include "visual-regression-tracker.jsString" .Values.vrtConfig.reactAppApiUrl }}',
  REACT_APP_STATIC_URL:
    '{{ include "visual-regression-tracker.jsString" .Values.vrtConfig.reactAppStaticUrl }}',
  REACT_APP_OIDC_AUTO_REDIRECT:
    '{{ include "visual-regression-tracker.jsString" .Values.vrtConfig.reactAppOidcAutoRedirect }}',
  PORT: '{{ include "visual-regression-tracker.jsString" .Values.vrtComponents.ui.service.port }}',
  VRT_VERSION: '{{ .Chart.AppVersion }}'
}
