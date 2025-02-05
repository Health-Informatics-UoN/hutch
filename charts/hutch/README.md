# Hutch (Relay + Bunny) Helm chart

This Helm chart deploys the [Hutch Relay](https://github.com/Health-Informatics-UoN/hutch-relay) and [Hutch Bunny](https://github.com/Health-Informatics-UoN/hutch-bunny) components along with their dependencies ([RabbitMQ](https://artifacthub.io/packages/helm/bitnami/rabbitmq) and [PostgreSQL](https://artifacthub.io/packages/helm/bitnami/postgresql)).

## Usage

### Local development

You can deploy all the components in the same cluster. You will need the connection details of the upstream Task API to are connecting the Relay instance to.

First you need to deploy relay and the dependencies, so set the `bunny.enabled` to `false`. You can use this yaml file, changing the necessary credentials:

```yaml
relay:
  enabled: true

  upstreamTaskApi:
    basicAuth:
      username: "CHANGEME"
      password: "CHANGEME"
    baseUrl: "https://CHANGEME"
    collectionId: "RQ-CC-CHANGEME"

bunny:
  enabled: false

rabbitmq:
  # Enables the rabbitmq templates
  enabled: true
  auth:
    username: "CHANGEME"
    password: "CHANGEME"

postgresql:
  enabled: true
  auth:
    username: "CHANGEME"
    password: "CHANGEME"
```

Then [setup the bunny credentials](#add-relay-user) in the relay node.

Copy the password and collection id, and we will pass these values to the bunny chart. Enable the bunny block in the `values.yaml` file and add this to the block:

```yaml
bunny:
  enabled: true
  extraEnvVars:
    # COLLECTION_ID is created in the Relay instance when creating a user.
    - name: COLLECTION_ID
      value: 0194cbaa-5b5f-7d86-815b-aad2ee2224fc
  taskApi:
    basicAuth:
      # Username is created in the Relay instance when creating a user.
      username: test-user-1
      # Password is created in the Relay instance when creating a user.
      password: "BdRoQP2z#sXsM79*"
  db:
    # Change to whatever the schema is in the postgresql database.
    schema: omop
```

Then seed the postgresql OMOP database with OMOP data. This is not covered under this `README.md`. You can use a tool like [Carrot](https://carrot.ac.uk/documentation) to map your data to OMOP. If you have OMOP data and want to seed it into the postgres database, ensure you've setup the schema using the Common Data Model found [here](https://github.com/OHDSI/CommonDataModel/releases). The standardized vocabulary tables can be retrieved from [Athena](https://athena.ohdsi.org/).

### Within SDE

Within an SDE, you only need to deploy the Relay node. So the `values.yaml` may look like this:

```yaml
relay:
  enabled: true

  upstreamTaskApi:
    basicAuth:
      username: "CHANGEME"
      password: "CHANGEME"
    baseUrl: "https://CHANGEME"
    collectionId: "RQ-CC-CHANGEME"

bunny:
  enabled: false

rabbitmq:
  # Enables the rabbitmq templates
  enabled: true
  auth:
    username: "CHANGEME"
    password: "CHANGEME"

postgresql:
  enabled: true
  auth:
    username: "CHANGEME"
    password: "CHANGEME"
```

Then [setup the bunny credentials](#add-relay-user) in the relay node.

You will probably also need to deploy the Relay ingress. See [here](#deploying-relay-with-ingress)

### Within a Data Provider

A Data Provider only needs the bunny instance installed. This also presumes there is already a PostgreSQL database with OMOP data within the Data Provider's network. If not, you can always deploy a PostgreSQL by enabled it in this chart.

```yaml
relay:
  enabled: false

bunny:
  enabled: true
  extraEnvVars:
    # COLLECTION_ID is created in the Relay instance when creating a user.
    - name: COLLECTION_ID
      value: CHANGEME
    - name: LOW_NUMBER_SUPPRESSION_THRESHOLD
      value: 'CHANGEME'
    - name: ROUNDING_TARGET
      value: 'CHANGEME'
  taskApi:
    basicAuth:
      # Username is created in the Relay instance when creating a user.
      username: CHANGEME
      # Password is created in the Relay instance when creating a user.
      password: "CHANGEME"
    baseUrl: "https://CHANGEME"
    collectionId: CHANGEME
  db:
    # Change to whatever the schema is in the postgresql database.
    auth:
      username: CHANGEME
      password: CHANGEME
    host: CHANGEME
    port: 5432
    dbName: CHANGEME
    schema: CHANGEME

rabbitmq:
  enabled: false

postgresql:
  enabled: false
```

## Add Relay user

Once the relay pod is running, you need to exec into it with

```sh
kubectl exec -n <namespace> <relay-pod-name> -- /bin/sh
```

Then you can create a user for the bunny node using the CLI:

```sh
dotnet Hutch.Relay.dll users add <CHANGEME>
```

This will return a response like this:

```sh
> dotnet Hutch.Relay.dll users add test-user-1
┌──────────┬─────────────┬──────────┬──────────────────┬───────────────┬──────────────────────────────────────┐
│ Username │ test-user-1 │ Password │ BdRoQP2z#sXsM79* │ Collection ID │ 0194cbaa-5b5f-7d86-815b-aad2ee2224fc │
└──────────┴─────────────┴──────────┴──────────────────┴───────────────┴──────────────────────────────────────┘
```

## Using existing kubernetes secrets

If you want to deploy the kubernetes secrets yourself for credentials, you can do so by setting the `existingSecretName` properties in each component.

```yaml
relay:
  enabled: true
  db:
    auth:
      existingSecretName: CHANGEME
  queue:
    auth:
      existingSecretName: CHANGEME
  upstreamTaskApi:
    basicAuth:
      existingSecretName: CHANGEME

bunny:
  enabled: true
  taskApi:
    basicAuth:
      existingSecretName: CHANGEME
  db:
    auth:
      existingSecretName: CHANGEME

rabbitmq:
  enabled: true
  auth:
    existingPasswordSecret: CHANGEME

postgresql:
  enabled: true
  auth:
    existingSecret: CHANGEME
```

You can also override the keys in the secret if needed. See the default values file.

## Deploying Relay with ingress

You will need to expose the Relay service through an ingress if your bunny instance is not deployed in the same Kubernetes cluster.

Ensure that the current cluster has an ingress controller. We recommend using [ingress-nginx](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx).

Create a tls certificate secret within the namespace relay is within. We suggest using [cert-manager](https://artifacthub.io/packages/helm/cert-manager/cert-manager) for managing tls certificates within Kubernetes.

To deploy an ingress object, the values for Relay might look something like this:

```yaml
relay:
  enabled: true
  ingress:
    enabled: true
    className: nginx
    tls:
      hosts:
        - CHANGEME
      secretName: CHANGEME
    hosts:
      - host: CHANGEME
        paths:
          - path: /
            pathType: Prefix
```

