# nginx-php-fpm

A chart that installs a nginx and a php-fpm deployment

## Install Chart

```console
helm install nginx-php-fpm oci://ghcr.io/kokuwaio/charts/nginx-php-fpm
```

_See [configuration](#configuration) below._

_See [`helm install`](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run these configuration commands:

```console
helm show values oci://ghcr.io/kokuwaio/charts/nginx-php-fpm
```

## Uninstall Chart

```console
helm uninstall nginx-php-fpm
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [`helm uninstall`](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrading the Helm Chart

```console
helm upgrade nginx-php-fpm oci://ghcr.io/kokuwaio/charts/nginx-php-fpm
```

_See [`helm upgrade`](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._
