# Visual Regression Tracker

Visual Regression Tracker is a backend and frontend application for tracking differences via image comparison. This Helm chart installs a Kubernetes statefulset containing the UI and API components.

If you want to run this chart with more than 1 replica, get sure you can use a [ReadWriteMany PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes), as the pods needs to share the imageUploads volume.

## Add Helm Repository

```console
helm repo add kokuwa https://kokuwaio.github.io/helm-charts
helm repo update
```

_See [`helm repo`](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
helm install vrt kokuwa/visual-regression-tracker
```

_See [configuration](#configuration) below._

_See [`helm install`](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run these configuration commands:

```console
helm show values kokuwa/visual-regression-tracker
```

## Uninstall Chart

```console
helm uninstall vrt
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [`helm uninstall`](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrading the Helm Chart

```console
helm upgrade vrt kokuwa/visual-regression-tracker
```

_See [`helm upgrade`](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

### From 0.x.0 to 1.0.0

Container config has been moved from `.Values.ui`, `.Values.api`, & `.Values.migration` to  `.Values.vrtComponents.ui`, `.Values.vrtComponents.api`, & `.Values.vrtComponents.migration`.

Default securityContexts and podSecurityContexts have been set.

PostgreSQL dependency has beend updated to 12.1.2 which changes the default PostgreSQL image from 14.x to 15.x. Follow the [official instructions](https://www.postgresql.org/docs/15/upgrading.html) to upgrade.
