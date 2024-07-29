# SharingHub

SharingHub is a web application offering collaborative services useful to developers or data scientists
working in the fields of AI and earth observation. It offers tools for managing datasets,
AI models and associated tools. Inspired by the HuggingFace platform, SharingHub brings the management
dimension of geographic information, and is deployable on top of any GitLab instance.

## Table of contents

- [Architecture](#architecture)
- [Getting started](#getting-started)
- [Deployment guide](#deployment-guide)
  - [Docker image](#docker-image)
    - [Build image](#build-image)
    - [Push image](#push-image)
  - [Create a robot account](#create-a-robot-account)
  - [Create a secret key](#create-a-secret-key)
  - [Configure a Gitlab Application for authentication](#configure-a-gitlab-application-for-authentication)
  - [Configure the server](#configure-the-server)
  - [Options](#options)
    - [Create a S3 bucket](#create-a-s3-bucket)
- [Copyright and License](#copyright-and-license)

## Architecture

The SharingHub is made of 3 components:

- [sharinghub-server](https://github.com/csgroup-oss/sharinghub-server): backend server with the API implementation.
  Can be requested from the web portal and compatible clients.
- [sharinghub-ui](https://github.com/csgroup-oss/sharinghub-ui): web portal, main entry-point for the users.
- [sharinghub-docs](https://github.com/csgroup-oss/sharinghub-docs): end-user documentation.

This repository is used to assemble these components as a single container image. Furthermore, you can find in
[Deployment guide](#deployment-guide) the necessary steps to deploy, as well as the deployment resources (Helm charts under `deploy/helm`).

## Getting started

Python 3.11 required.

Setup the environment:

```bash
python -mvenv .venv
source .venv/bin/activate
```

Install the [pre-commit](https://pre-commit.com/) hooks:

```bash
pre-commit install --install-hooks
```

Follow the instructions in each component `README.md`:

- `sharinghub-server`
- `sharinghub-ui`
- `sharinghub-docs`

## Deployment guide

### Docker image

#### Build image

You must first build the images of each components. Each of them describes its build steps in their own `README.md`.

We assemble these images as one image, the `sharinghub` image:

```bash
docker build . -t <docker-registry>/sharinghub:latest
```

#### Push image

You can now push the final image:

```bash
docker push <docker-registry>/sharinghub:latest
```

### Create a robot account

Create a robot account in the docker registry to access the image.

```bash
kubectl create namespace sharinghub

kubectl create secret docker-registry regcred --docker-username='<robot-username>' --docker-password='<robot-password>' --docker-server='<docker-registry>' --namespace sharinghub
```

### Create a secret key

The server needs a secret key for security purposes, create the secret:

```bash
kubectl create secret generic sharinghub --from-literal session-secret-key="<uuid>" --namespace sharinghub
```

### Configure a Gitlab Application for authentication

You will need to create an application in your Gitlab instance in order to use SharingHub.

Configure an application in the GitLab instance for OpenID connect authentication:

Callback URLs example:

```txt
http://localhost:8000/api/auth/login/callback
https://sharinghub.<domain-name>/api/auth/login/callback
```

> Note: localhost URL is for development purposes, if you don't want it you can remove it.

![Configure application](./assets/configure-application.png)

You will be given a secret, and an application id, we will use them to create the following secret:

```bash
kubectl create secret generic sharinghub-oidc --from-literal client-id="<application-id>" --from-literal client-secret="<application-secret>" --namespace sharinghub
```

If you want, you can also set a default token, allowing use to use SharingHub without being authenticated, because the token will be used as default. The default token can be a personal Access Token, or a Group Access Token. Group tokens needs at least the role `Reporter`, and the scopes `read_api`, `read_repository`. Personal tokens needs `api` scope.

The secret creation will look like this:

```bash
kubectl create secret generic sharinghub-oidc  --from-literal default-token="<default-token>" --from-literal client-id="<client-id>" --from-literal client-secret="<client-secret>" --namespace sharinghub
```

### Configure the server

You're almost there. The last step is to create your own configuration. The default one in the charts is not ready-to-use out of the box.

Create your own `values.<platform>.yaml` file:

```yaml
config: |-
  # yaml config here

image:
  repository: <docker-registry>/sharinghub
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: "latest"

imagePullSecrets:
  -  name: regcred

ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10g
  hosts:
    - host: sharinghub.<domain-name>
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - secretName: sharinghub-tls
      hosts:
        - sharinghub.<domain-name>
```

Complete the values, replace `<domain-name>` with your target domain, and configure the server. Please check the server configuration in the file `CONFIGURATION.md` of the SharingHub server repository.

When all is done, install/update your deployment:

```bash
# Install & Update
helm upgrade --install -n sharinghub --create-namespace sharinghub ./deploy/helm/sharinghub -f ./deploy/helm/values.<platform>.yaml
```

### Options

#### Create a S3 bucket

You can use a S3 bucket to store your datasets.

If you chose to use one, you need to create a s3 bucket in your provider and create the associated secret:

```bash
kubectl create secret generic sharinghub-s3 --from-literal access-key="<access-key>" --from-literal secret-key="<secret-key>" --namespace sharinghub
```

For more detail about S3 configuration you can check [this](https://github.com/csgroup-oss/sharinghub-server/blob/main/CONFIGURATION.md#s3).

## Copyright and License

Copyright 2024 `CS GROUP - France`

**SharingHub**  is an open source software, distributed under the Apache License 2.0. See the [`LICENSE`](./LICENSE) file for more information.
