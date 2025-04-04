# mysqldump

mysqldump is a tool for creating backups of MySQL databases in the form of a .sql file.

## TLDR

```console
helm repo add kokuwa https://kokuwaio.github.io/helm-charts
helm install kokuwa/mysqldump --set mysql.host=mysql;mysql.username=root,mysql.password=password
```

## Introduction

This chart helps set up a cronjob or one time job to backup a MySQL database with mysqldump into a Persistent Volume. You can specify an existing PVC, or helm will create one for you.

## Prerequisites

- Kubernetes 1.21
- Helm 3.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install kokuwa/mysqldump --set mysql.host=mysql,mysql.username=root,mysql.password=password
```

This command will create a cronjob to run a job once a day to backup the databases found on the host `mysql`

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the mysqldump chart and their default values.
<!-- textlint-disable -->
| Parameter                                     | Description                                                                     | Default                      |
| --------------------------------------------- | ------------------------------------------------------------------------------- | ---------------------------- |
| image.registry                                | Name of docker registry to use                                                  | quay.io                      |
| image.repository                              | Name of image to use                                                            | monotek/gcloud-mysql         |
| image.tag                                     | Version of image to use (uses appVersion form Chart.yaml as default if not set) | ""                           |
| image.pullPolicy                              | Pull Policy to use for image                                                    | IfNotPresent                 |
| mysql.db                                      | MySQL db(s) to backup (optional)                                                | mysql                        |
| mysql.host                                    | MySQL host to backup                                                            | mysql                        |
| mysql.username                                | MySQL username                                                                  | root                         |
| mysql.password                                | MySQL password                                                                  | ""                           |
| mysql.existingSecret                          | existing secret name, used to get MySQL password (if set)                       |                              |
| mysql.existingSecretKey                       | existing secret key                                                             | mysql-root-password          |
| mysql.port                                    | MySQL port                                                                      | 3306                         |
| mysql.dumpOptions                             | options to pass onto MySQL dump                                                 | "--opt --single-transaction" |
| schedule                                      | crontab schedule to run on. set as `now` to run as a one time job               | "0 3 \* \* \*"               |
| rsync.options                                 | options to pass onto rsync                                                      | "-av"                        |
| debug                                         | print some extra debug logs during backup                                       | false                        |
| additionalSteps                               | run these extra shell steps after all backup jobs completed                     | []                           |
| successfulJobsHistoryLimit                    | number of successful jobs to remember                                           | 1                            |
| failedJobsHistoryLimit                        | number of failed jobs to remember                                               | 1                            |
| sshMountpath                                  | User's path (used to mount SSH key if needed)                                   | "/home/cloudsdk"             |
| persistentVolumeClaim                         | existing Persistent Volume Claim to backup to, leave blank to create a new one  |                              |
| persistence.enabled                           | create new PVC (unless `persistentVolumeClaim` is set)                          | true                         |
| persistence.size                              | size of PVC to create                                                           | 8Gi                          |
| persistence.accessMode                        | accessMode to use for PVC                                                       | ReadWriteOnce                |
| persistence.storageClass                      | storage class to use for PVC                                                    |                              |
| persistence.subPath                           | subPath for PVC                                                                 |                              |
| housekeeping.enabled                          | delete olf backups in pvc                                                       | true                         |
| housekeeping.keepDays                         | keep last x days of backups in PVC                                              | 10                           |
| upload.googlestoragebucket.enabled            | upload backups to google storage                                                | false                        |
| upload.googlestoragebucket.bucketname         | google storage address                                                          | gs://mybucket/test           |
| upload.googlestoragebucket.jsonKeyfile        | json keyfile for serviceaccount                                                 | ""                           |
| upload.googlestoragebucket.existingSecret     | specify a secretname to use                                                     | nil                          |
| upload.googlestoragebucket.usingGCPController | enable the use of the GCP Service Account Controller                            | false                        |
| upload.googlestoragebucket.serviceAccountName | specify a service account name to use                                           | nil                          |
| upload.ssh.enabled                            | upload backups via SSH                                                          | false                        |
| upload.ssh.existingSecret                     | specify a secretname to use                                                     | nil                          |
| upload.ssh.user                               | SSH user                                                                        | backup                       |
| upload.ssh.host                               | SSH server URL                                                                  | yourdomain.com               |
| upload.ssh.dir                                | SSH directory on server                                                             | /backup                      |
| upload.ssh.privatekey                         | SSH user private key                                                            | ""                           |
| upload.openstack.enabled                      | upload backups via swift to openstack                                           | false                        |
| upload.openstack.user                         | username                                                                        | backup@mydomain              |
| upload.openstack.userDomain                   | user-domain                                                                     | default                      |
| upload.openstack.password                     | password, overridden by `existingSecret`/`existingSecretKey` if set             |                              |
| upload.openstack.authUrl                      | openstack auth URL (v3)                                                         | <https://mydomain:5000/v3>   |
| upload.openstack.project                      | project name                                                                    | my_project                   |
| upload.openstack.projectDomain                | project domain                                                                  | default                      |
| upload.openstack.destination                  | destination path, starting witch container                                      | backup/mysql                 |
| upload.openstack.existingSecret               | optional, specify a secret name to use for password                             |                              |
| upload.openstack.existingSecretKey            | optional, specify a secret key to use for password                              | openstack-backup-password    |
| upload.openstack.ttlDays                      | days to set time-to-live on uploaded objects (0 to disable)                     | 30                           |
| upload.s3.enabled                             | upload backups to s3 storage                                                    | false                        |
| upload.s3.bucketname                          | s3 bucket name                                                                  | mysql-backup                 |
| upload.s3.endpoint                            | URL endpoint of the S3 service                                                  | <https://mydomain.com>       |
| upload.s3.region                              | AWS region to use                                                               | us-east-1                    |
| upload.s3.accesskey                           | s3 access key                                                                   | ""                           |
| upload.s3.secretkey                           | s3 secret key                                                                   | ""                           |
| upload.s3.existingSecret                      | optional, existing secret name, used to get s3 Secret key (if set)              | ""                           |
| upload.s3.existingSecretKey                   | optional, specify a secret key to use for s3 Secret key                         | S3_SECRET_KEY                |
| resources                                     | resource definitions                                                            | {}                           |
| nodeSelector                                  | k8s-node selector                                                               | {}                           |
| tolerations                                   | tolerations                                                                     | \[]                          |
| affinity                                      | affinity                                                                        | {}                           |
| securityContext.enabled                       | set true to change default security context of job/cronjob                      | false                        |
| securityContext.fsGroup                       | group ID to use                                                                 | 999                          |
| securityContext.runAsUser                     | user ID to use                                                                  | 999                          |
<!-- textlint-enable -->

### Auto generating the gcp service account

By enabling the flag `upload.googlestoragebucket.usingGCPController` and having a GCP Service Account Controller deployed in your cluster, it is possible to autogenerate and inject the service account used for the storage bucket access. For more information see <https://github.com/kiwigrid/helm-charts/tree/master/charts/gcp-serviceaccount-controller>

```console
helm install kokuwa/mysqldump --name my-release --set persistentVolumeClaim=name-of-existing-pvc
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install kokuwa/mysqldump --name my-release -f values.yaml
```
