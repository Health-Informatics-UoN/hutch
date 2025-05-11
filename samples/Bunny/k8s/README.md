# Deploy centralised Prometheus and Grafana

Here we are deploying centralised services for Prometheus and Grafana that all other services can use

Configuring new services may involve redeploying these with modified config (`<x>.values.yml`)

- Create monitoring namespace: `kubectl create namespace monitoring`
- Deploy Prometheus: `helm install -f monitoring/prometheus.values.yml -n monitoring prometheus oci://registry-1.docker.io/bitnamicharts/prometheus`
- Deploy Grafana Loki:
  - Add repository if necessary: `helm repo add grafana https://grafana.github.io/helm-charts`, `helm repo update`
  - `helm install -f monitoring/loki.values.yml -n monitoring loki grafana/loki`
- Deploy Grafana Alloy:
  - `helm install -f monitoring/alloy.values.yml -n monitoring alloy grafana/alloy`
- Deploy Grafana: `helm install -f monitoring/grafana.values.yml -n monitoring grafana oci://registry-1.docker.io/bitnamicharts/grafana`

when changing any configs for the above e.g. to add data sources etc. perform a `helm upgrade` with the values files containing the updated configuration.

# Deploy a bunny with its own postgres db

`// TODO: what about bunny with existing postgres?`:
- Do we need to refactor our sample configs to be configurable?
- Could do multiple configmap / secret definitions and then multi-apply configs?
- Or look at kustomize?
- Or do we wait for helm?
- Honestly the steps remain the same just skipping creating and populating the DB, and then different config

Here we are creating a standalone bunny setup (separate bunnies for availability and distribution)
connected to their own postgres db, with logging and monitoring via centralised services in the cluster.

- Create a namespace for our bunny setup: `kubectl create namespace bunny1`
- Create a secret for the postgres password: `kubectl create secret generic postgres-secret -n bunny1 --from-literal=postgres-password=postgres`
- Install postgres: `helm install -f db/postgres.values.yml -n bunny1 postgres oci://registry-1.docker.io/bitnamicharts/postgresql`
- Run `omop-lite` as a one-off Job to load data: `kubectl apply -f db/omop-lite.job.yml -n bunny1`
- Deploy bunnies:
  - Create secret for Task API config: `kubectl create secret generic bunny-task-api -n bunny1 --from-env-file=../sample.bunny-task-api.env`
  - `kubectl apply -f bunny_standalone_separate-queues.yml -n bunny1`

Everything's running <3

To get postgres to show up in Prometheus (and therefore Grafana) a scrape config is required, similar to:

```yaml
- job_name: bunny1-postgres
      static_configs:
        - targets: ['postgres-postgresql-metrics.bunny1.svc.cluster.local:9187']
```

To get Bunny to show up in Grafana (via Loki and Alloy...) make sure the namespace is added to the discovery scope in Alloy's config, e.g.:

```
discovery.kubernetes "pod" {
  role = "pod"

  namespaces {
    names = ["bunny1", "other namespace"]
  } 
  
  ...
}
```

`// TODO: Bunny OpenTelemetry`

# Deploy a Relay with its own postgres db

`// TODO: Is bunny + relay in one config ever useful?`
- Surely even in the same cluster you would separate them, and you'd only even use Relay if you had more than one bunny?

Here we are creating a standalone Relay setup 
connected to its own postgres db, with logging and monitoring via centralised services in the cluster.
Separate Bunnies can be connected later.

- Create a namespace for our Relay setup: `kubectl create namespace hutch-relay`
- Create a secret for the postgres password: `kubectl create secret generic postgres-secret -n hutch-relay --from-literal=postgres-password=postgres`
- Install postgres: `helm install -f db/postgres.values.yml -n hutch-relay postgres oci://registry-1.docker.io/bitnamicharts/postgresql`
- Run Relay CLI as a one off Job to run migrations:
  - Create secret for Relay connection string: `kubectl create secret generic relay-connection-string -n hutch-relay --from-literal=ConnectionStrings__Default="Server=postgres-postgresql;Port=5432;Database=hutch-relay;User Id=postgres;Password=postgres"`
  - Run the CLI `kubectl apply -f relay/relay-migrations.job.yml -n hutch-relay`
- Install RabbitMQ: `helm install -f relay/rabbitmq.values.yml rabbitmq -n hutch-relay oci://registry-1.docker.io/bitnamicharts/rabbitmq`
- Deploy Relay:
  - Create secret for Task API config: `kubectl create secret generic relay-task-api -n hutch-relay --from-env-file=../sample.relay-task-api.env`
  - `kubectl apply -f relay/relay.yml -n hutch-relay`

(In future, consider standing up Rabbitmq separately to ease a) a service on the GUI and b) monitoring)

To get postgres and rabbit to show up in Prometheus (and therefore Grafana) a scrape config is required, similar to:

```yaml
- job_name: hutch-relay-postgres
      static_configs:
        - targets: ['postgres-postgresql-metrics.hutch-relay.svc.cluster.local:9187']
- job_name: hutch-relay-rabbitmq
      static_configs:
        - targets: ['rabbitmq.hutch-relay.svc.cluster.local:9419']
```

To get Relay to show up in Grafana (via Loki and Alloy...) make sure the namespace is added to the discovery scope in Alloy's config, e.g.:

```
discovery.kubernetes "pod" {
  role = "pod"

  namespaces {
    names = ["hutch-relay", "other namespace"]
  } 
  
  ...
}
```

`// TODO: Relay OpenTelemetry`

# Deploy a Bunny connected to Relay

Here we are configuring Relay (in kubernetes) for a new Bunny, and then deploying that Bunny pointing at Relay.

Relay configuration depends on where and how Relay is deployed, but this is an example where Relay is in a kubernetes somewhere and Bunny is deployed in a kubernetes somewhere.
Doesn't really matter if it's ths same cluster or not.

The general Bunny deployment steps (e.g. with or without database) can be followed as elsewhere; the important thing is the Relay configuration.

- Create a namespace for our bunny setup: `kubectl create namespace bunny2`
- Create a secret for the postgres password: `kubectl create secret generic postgres-secret -n bunny2 --from-literal=postgres-password=postgres`
- (Optionally deploy postgres and run omop-lite)
- Configure Relay to add a new user + subnode for this bunny
  - Exec into the running Relay container and use the Relay CLI to add a user and retrieve their connection details
    - today this is imperative via the CLI - in future declarative config will improve this experience
- Deploy bunnies:
  - Create secret for Task API config: `kubectl create secret generic bunny-task-api -n bunny2 --from-env-file=../sample.bunny-task-api.env`
    - note this uses Relay as the Task API and the details from the job run above
  - `kubectl apply -f bunny_standalone_single-queue.yml -n bunny2`

Everything's running <3

To get postgres to show up in Prometheus (and therefore Grafana) a scrape config is required, similar to:

```yaml
- job_name: bunny1-postgres
      static_configs:
        - targets: ['postgres-postgresql-metrics.bunny1.svc.cluster.local:9187']
```

To get Bunny to show up in Grafana (via Loki and Alloy...) make sure the namespace is added to the discovery scope in Alloy's config, e.g.:

```
discovery.kubernetes "pod" {
  role = "pod"

  namespaces {
    names = ["bunny1", "other namespace"]
  } 
  
  ...
}
```