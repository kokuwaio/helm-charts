# kokuwa.io helm charts

[Helm](https://helm.sh/) charts for [Kokuwa](https://kokuwa.io) project maintained charts which can be installed on [Kubernetes](https://kubernetes.io/)

## Repository info

[![Releases downloads](https://img.shields.io/github/downloads/kokuwaio/helm-charts/total.svg)](https://github.com/kokuwaio/helm-charts/releases)
[![Release Charts](https://github.com/kokuwaio/helm-charts/workflows/Release%20Charts/badge.svg)](https://github.com/kokuwaio/helm-charts/commits/main)

## Install a chart

The charts are published as OCI artifacts to the GitHub Container Registry. Installing them needs Helm 3.8 or later; no `helm repo add` is needed:

```console
helm install my-release oci://ghcr.io/kokuwaio/charts/<chart>
```

For example:

```console
helm install mysqldump oci://ghcr.io/kokuwaio/charts/mysqldump
```

The Helm repository at `https://kokuwaio.github.io/helm-charts` is no longer updated. Switch to the OCI registry to get new chart versions.

## Sources

The charts sources can be found here:

* [https://github.com/kokuwaio/helm-charts](https://github.com/kokuwaio/helm-charts)

The OCI chart packages can be found here:

* [https://github.com/orgs/kokuwaio/packages?repo_name=helm-charts](https://github.com/orgs/kokuwaio/packages?repo_name=helm-charts)

Helm Releases can be found here:

* [https://github.com/kokuwaio/helm-charts/releases](https://github.com/kokuwaio/helm-charts/releases)
