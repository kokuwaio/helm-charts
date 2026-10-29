# Visual Regression Tracker

Visual Regression Tracker is a backend and frontend application for tracking differences via image comparison. This Helm chart installs a Kubernetes statefulset containing the UI and API components.

If you want to run this chart with more than 1 replica, get sure you can use a [ReadWriteMany PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes), as the pods needs to share the imageUploads volume.

## Install Chart

```console
helm install vrt oci://ghcr.io/kokuwaio/charts/visual-regression-tracker
```

_See [configuration](#configuration) below._

_See [`helm install`](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run these configuration commands:

```console
helm show values oci://ghcr.io/kokuwaio/charts/visual-regression-tracker
```

## Uninstall Chart

```console
helm uninstall vrt
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [`helm uninstall`](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrading the Helm Chart

```console
helm upgrade vrt oci://ghcr.io/kokuwaio/charts/visual-regression-tracker
```

_See [`helm upgrade`](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

### From 5.x to 6.0.0

This updates Visual Regression Tracker to 5.9.0 (API 5.7.0, UI 5.6.0, migration 5.5.0). See the [release notes](https://github.com/Visual-Regression-Tracker/Visual-Regression-Tracker/releases/tag/5.9.0).
The UI settings `vrtConfig.reactAppStaticUrl` and `vrtConfig.reactAppOidcAutoRedirect` have been added. Other new optional API settings, like OIDC, can be set via `vrtComponents.api.extraEnv`.

The Bitnami PostgreSQL dependency chart has been replaced by the [CloudPirates postgres chart](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/postgres), which uses the official PostgreSQL 18 image.
The values stay under the `postgresql` key. Remove Bitnami specific values like `postgresql.primary.*` and `postgresql.image.*` from your values: the new chart also reads `postgresql.image.*` and would run the Bitnami image with incompatible data paths.
The VRT database user is now configured via `postgresql.customUser.name`, `postgresql.customUser.database` and `postgresql.customUser.password` instead of `postgresql.auth.*`, which now configures the PostgreSQL superuser. See the chart's values for the available options.

The existing database is not migrated automatically. To keep your data, dump it and import it into the new database (release name `vrt` in the examples):

1. Stop VRT and wait until its pod is gone:

   ```console
   kubectl scale statefulset vrt-visual-regression-tracker --replicas=0
   kubectl wait --for=delete pod/vrt-visual-regression-tracker-0 --timeout=300s
   ```

2. Dump the database:

   ```console
   kubectl exec vrt-postgresql-0 -- sh -c 'PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -U vrt vrt' > vrt.sql
   ```

3. Save your values and adjust them as described above:

   ```console
   helm get values vrt -o yaml > vrt-values.yaml
   ```

4. Delete the old PostgreSQL StatefulSet, its PVC and its Secret:

   ```console
   kubectl delete statefulset vrt-postgresql
   kubectl delete pvc data-vrt-postgresql-0
   kubectl delete secret vrt-postgresql
   ```

5. Upgrade the chart with VRT stopped, so its migrations don't run against the empty database. `--reset-values` makes sure the new chart defaults are used, `--wait` waits for PostgreSQL to be ready:

   ```console
   helm upgrade vrt oci://ghcr.io/kokuwaio/charts/visual-regression-tracker --version 6.0.0 --reset-values -f vrt-values.yaml --set replicaCount=0 --wait
   ```

6. Import the dump:

   ```console
   kubectl exec -i vrt-postgresql-0 -- sh -c 'PGPASSWORD="$CUSTOM_PASSWORD" psql -v ON_ERROR_STOP=1 -U vrt vrt' < vrt.sql
   ```

7. Start VRT again:

   ```console
   helm upgrade vrt oci://ghcr.io/kokuwaio/charts/visual-regression-tracker --version 6.0.0 --reset-values -f vrt-values.yaml --wait
   ```

### From 4.0.x to 5.0.0

Auth proxy was removed as it does nto work as expected.

The `reactAppApi.protocol` & `reactAppApi.url` have been removed and `reactAppApiUrl` is used again.

### From 3.0.x to 4.0.0

This version adds a proxy in fornt of the API server which protects it via basic auth. The configuration can be done via `authProxy.basicAuth.username`, `authProxy.basicAuth.password`. The password can also be populated by predefined secret via `secrets.authProxy`.

The `secrets.apiUrl` secrets has been removed.

The `reactAppApiUrl` variables has been split up into `reactAppApi.protocol` & `reactAppApi.url`.

The `vrtComponents.api.ingress` config has been moved to `authProxy.ingress`.

### From 2.0.x to 3.0.0

This updates Visual Regression Tracker to 5.0.3. Please follow the [official migration steps](https://github.com/Visual-Regression-Tracker/Visual-Regression-Tracker/releases/tag/5.0.0):

The postgres dependency chart has also been updated to version 13.2.23. This major version changes the default PostgreSQL image from 15.x to 16.x. Follow [the official instructions](https://www.postgresql.org/docs/16/upgrading.html) to upgrade to 16.x.

### From 1.0.x to 2.0.0

Renamed migration securityContext var from `.Values.vrtComponents.migration.initSecurityContext` to `.Values.vrtComponents.migration.securityContext`
Fixed securityContext config for API and UI containers, where the configvalues were ignored.
Added `seccompProfile` with default of `type: RuntimeDefault` to `podSecurityContext`.
`readOnlyRootFilesystem` setting was removed.

### From 0.x.0 to 1.0.0

Container config has been moved from `.Values.ui`, `.Values.api`, & `.Values.migration` to  `.Values.vrtComponents.ui`, `.Values.vrtComponents.api`, & `.Values.vrtComponents.migration`.

Default securityContexts and podSecurityContexts have been set.

PostgreSQL dependency has beend updated to 12.1.2 which changes the default PostgreSQL image from 14.x to 15.x. Follow the [official instructions](https://www.postgresql.org/docs/15/upgrading.html) to upgrade.
