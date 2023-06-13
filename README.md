# LightDevOps

LightDevOps is a universal GitLab CI/CD pipeline as an easier alternative to
GitLab's Auto DevOps. It automatically builds, tests and deploys the application
to the Kubernetes cluster, only a Dockerfile and a Helm chart is needed.

## Quickstart

In the Gitlab project, assuming that the Dockerfile is in the repository, Helm
chart is in the _./chart_ directory and the [Kubernetes cluster][gitlab-cluster]
is also connected.

In _Settings_ -> _CI/CD_ -> under _General pipelines_ tab, set the path to the
_CI/CD configuration file_:

    https://lightdevops.cze.tech/cicd/gitlab-kube-BA-TA-DA.yaml

In _Settings_ -> _Repository_ -> under _Deploy tokens_ tab,
[create a token][gitlab-deploy-token] with name `gitlab-deploy-token` and at
least `read_registry` scope.

Optionally set variable `TEST_UNIT_COMMAND` with docker image command that runs
unit tests.

The next commit creates a pipeline that builds, tests and (in the case of the
default branch) deploys the application to the Kubernetes cluster. To deploy on
the manual trigger, use `DM` instead of `DA` in the URL.

## Customization

Customization is done by CI/CD variables.

### Environment

For an explanation of working with environments, see
[Environments](#environments).

| Name                        | Type     | Description                  | Default value |
| --------------------------- | -------- | ---------------------------- | ------------- |
| `ENVIRONMENT_PROD_NAME`     | Variable | Production environment name  | `prod`        |
| `ENVIRONMENT_STAG_NAME`     | Variable | Staging environment name     | `stag`        |
| `ENVIRONMENT_<0_to_9>_NAME` | Variable | Additional environment names | None          |

### Build

If `BUILD_ENVIRONMENTS` is set to `true`, all other variables are within
[the scope for the environment][gitlab-env-scope].

| Name                        | Type     | Description                                                                                          | Default value                   |
| --------------------------- | -------- | ---------------------------------------------------------------------------------------------------- | ------------------------------- |
| `BUILD_ENVIRONMENTS`        | Variable | `true` to create build jobs for individual environments (case-insensitive)                           | None                            |
| `BUILD_ENABLED`             | Variable | `auto` to create build job, `manual` to runs it on the manual trigger (case-insensitive)             | Depend on [variant](#variants)  |
| `BUILD_FILE_CONTENT_<name>` | File     | Add a file with the given content to the repository before building, `<name>` can be any custom name | None                            |
| `BUILD_FILE_PATH_<name>`    | Variable | The relative path within the repository to place corresponding file by `<name>`                      | None                            |
| `DOCKER_PATH`               | Variable | The relative path to the build's context                                                             | `.`                             |
| `DOCKER_FILE`               | Variable | The relative path to the Dockerfile within the repository                                            | Docker's default (`Dockerfile`) |
| `DOCKER_FILE`               | File     | Dockerfile (if the bundled Dockerfile is not to be used)                                             | None                            |
| `DOCKER_ARG_<name>`         | Variable | Set Docker's build-time variable `<name>` (docker --build-arg `<name>`=VALUE)                        | None                            |

### Test

If `BUILD_ENVIRONMENTS` is set to `true`, all variables except for
`TEST_PRECOMMIT_ENABLED`are within
[the scope for the environment][gitlab-env-scope].

| Name                     | Type     | Description                                                                                                                                     | Default value                  |
| ------------------------ | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `TEST_ENABLED`           | Variable | `auto` to create test jobs, `manual` to run them on the manual trigger (case-insensitive, test command for corresponding test must also be set) | Depend on [variant](#variants) |
| `TEST_UNIT_COMMAND`      | Variable | Docker image command to run unit tests                                                                                                          | None                           |
| `TEST_PRECOMMIT_ENABLED` | Variable | `true` to enable [pre-commit] test, `manual` to run it on the manual trigger (case-insensitive, overwrites `TEST_ENABLED`)                      | None                           |
| `TEST_PRECOMMIT_FILE`    | Variable | The relative path to [pre-commit] configuration file within the repository                                                                      | `.pre-commit-config.yaml`      |
| `TEST_<0_to_9>_COMMAND`  | Variable | Docker image command to run another tests                                                                                                       | None                           |

### Deploy and clean

All variables are within [the scope for the environment][gitlab-env-scope].

| Name                          | Type     | Description                                                                                 | Default value                                                  |
| ----------------------------- | -------- | ------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `DEPLOY_ENABLED`              | Variable | `auto` to create deploy jobs, `manual` to run them on the manual trigger (case-insensitive) | Depend on [variant](#variants)                                 |
| `DEPLOY_URL`                  | Variable | [URL for an environment][gitlab-env-url]                                                    | None                                                           |
| `KUBE_NAMESPACE`              | Variable | Kubernetes namespace to deploy                                                              | GitLab's default (`<project_name>-<project_id>-<environment>`) |
| `HELM_VALUES_<name>`          | Variable | Helm values URL, `<name>` can be any custom name                                            | None                                                           |
| `HELM_VALUES_<name>`          | File     | Helm values in YAML format, `<name>` can be any custom name                                 | None                                                           |
| `HELM_SET_<name>`             | Variable | Helm values in key1=val1,key2=val2,... format, `<name>` can be any custom name              | None                                                           |
| `HELM_SETSTRING_<name>`       | Variable | Helm STRING values in key1=val1,key2=val2,... format, `<name>` can be any custom name       | None                                                           |
| `HELM_SETFILE_CONTENT_<name>` | File     | Helm value from the given content, `<name>` can be any custom name                          | None                                                           |
| `HELM_SETFILE_KEY_<name>`     | Variable | Helm key to value by `<name>`                                                               | None                                                           |
| `HELM_CHART`                  | Variable | Helm chart path within the repository or chart name if `HELM_REPO` is set                   | `chart`                                                        |
| `HELM_REPO`                   | Variable | Helm chart repository URL (if the bundled chart is not to be used)                          | None                                                           |
| `HELM_USERNAME`               | Variable | Helm chart repository username                                                              | None                                                           |
| `HELM_PASSWORD`               | Variable | Helm chart repository password                                                              | None                                                           |
| `HELM_KEY_REPOSITORY`         | Variable | Helm chart key to set image repository                                                      | `image.repository`                                             |
| `HELM_KEY_TAG`                | Variable | Helm chart key to set image tag                                                             | `image.tag`                                                    |
| `HELM_KEY_SECRET`             | Variable | Helm chart key to set registry secret name                                                  | `imagePullSecrets[0].name`                                     |
| `HELM_DEBUG`                  | Variable | `true` to enable verbose Helm output and disable atomic flag (case-insensitive)             | None                                                           |

## Variants

There are variants which define default values for [variables](#customization)
`BUILD_ENABLED`, `TEST_ENABLED` and `DEPLOY_ENABLED` defined by letters in
filename of CI/CD configuration file. Base variant without default values is:

    gitlab-kube.yaml

and variant with enabled automatic build is:

    gitlab-kube-BA.yaml

All available variants:

| Variant     | Variable         | Default value |
| ----------- | ---------------- | ------------- |
| _-BA_       | `BUILD_ENABLED`  | `auto`        |
| _-BM_       | `BUILD_ENABLED`  | `manual`      |
| _-Bx-TA_    | `TEST_ENABLED`   | `auto`        |
| _-Bx-TM_    | `TEST_ENABLED`   | `manual`      |
| _-Bx-Tx-DA_ | `DEPLOY_ENABLED` | `auto`        |
| _-Bx-Tx-DM_ | `DEPLOY_ENABLED` | `manual`      |

It is not possible to define a default value for the next stage without the
previous one, e.g. for `TEST_ENABLED` without `BUILD_ENABLED`.

## Environments

There are two predefined environments, `prod` as a production environment and
`stag` as a staging environment. The [variables](#customization)
`ENVIRONMENT_<0_to_9>_NAME` can be used to define another 10 environments.

Deployment jobs are created for all defined environments. Creating a deployment
job for certain environment only, e.g. production environment, is possible by
setting `DEPLOY_ENABLED` only for `prod` environment. In the case of the variant
with enabled deployment by default, it is possible to set `DEPLOY_ENABLED` with
the value `false` (or anything instead of `auto` and `manual`) for `stag`
environment.

The usual setup is automatic deployment to the staging environment and manual to
the production environment so it is possible to use the _-BA-TA-DM_
[variant](#variants) and set `DEPLOY_ENABLED` to `auto` for `stag` environment.

With `BUILD_ENVIRONMENTS` it is possible to create separate build and test jobs
for each environment. This can be used when the environment settings are
directly in the builded image (e.g. PWA or mobile applications).

## Helm chart requirements

Some values must be possible to set in the Helm chart, but these are standard
conventions, so it is assumed that the chart does not need to be modified. If
necessary, it is possible to change keys that set these values with CI/CD
variables.

| Description                                                 | Default value              | Variable              |
| ----------------------------------------------------------- | -------------------------- | --------------------- |
| Image repository                                            | `image.repository`         | `HELM_KEY_REPOSITORY` |
| Image tag                                                   | `image.tag`                | `HELM_KEY_TAG`        |
| Registry secret ([imagePullSecrets of a pod][k8s-registry]) | `imagePullSecrets[0].name` | `HELM_KEY_SECRET`     |

## Troubleshooting

- When the deploy job failed with
  `error: You must be logged in to the server (Unauthorized)` it is necessary in
  the affected GitLab managed cluster, under _Advanced settings_ tab, click
  _Clear cluster cache_.

## Build this application

The application itself is a static web page where the CI/CD pipelines are in the
_cicd_ directory.

### Build from code

Requirements:

- [Make]
- [pandoc]
- [gomplate]

Build is done with:

```shell
make
```

then the output is in the _./build/web_ directory.

The Dockerfile and Helm chart are also part of this repository so it can be
easily build and deployed to Kubernetes (e.g. from GitLab by the LightDevOps
pipeline itself).

### Run from Docker Hub

Run the image from Docker Hub:

```shell
docker run -p 80:80 czetech/lightdevops
```

### Install to Kubernetes using Helm

Setup Helm repository:

```shell
helm repo add czetech https://charts.cze.tech/
```

Install Helm chart:

```shell
helm install lightdevops czetech/lightdevops \
  --set ingress.enabled=true \
  --set ingress.hosts[0]=<ingress-host>
```

see the [chart] for more options.

## Source code

The source code is available at <https://github.com/czetech/lightdevops>.

[chart]: https://github.com/czetech/lightdevops/tree/main/chart
[gomplate]: https://docs.gomplate.ca/installing/
[gitlab-cluster]: https://docs.gitlab.com/ee/user/infrastructure/clusters/connect/
[gitlab-deploy-token]: https://docs.gitlab.com/ee/user/project/deploy_tokens/#gitlab-deploy-token
[gitlab-env-scope]: https://docs.gitlab.com/ee/ci/environments/#scope-environments-with-specs
[gitlab-env-url]: https://docs.gitlab.com/ee/ci/environments/#environment-url
[k8s-registry]: https://kubernetes.io/docs/concepts/containers/images/#using-a-private-registry
[make]: https://www.gnu.org/software/make/
[pandoc]: https://pandoc.org/installing.html
[pre-commit]: https://pre-commit.com/
