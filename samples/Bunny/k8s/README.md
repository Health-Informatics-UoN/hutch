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

when changing any configs for the above e.g. to add data sources or scrape config etc. perform a `helm upgrade` with the values files containing the updated configuration.

# Deploy a bunny with its own postgres db

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

Bunny will show up in Grafana via kubernetes pod logs, no specific configuration needed.

# Deploy a Relay with its own postgres db