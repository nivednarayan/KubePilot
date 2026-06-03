# ADR-004: Grafana Loki over ELK stack for log aggregation

## Decision
Use Grafana Loki and Promtail for log aggregation instead 
of the ELK stack (Elasticsearch, Logstash, Kibana).

## Reasoning
Loki is designed specifically for Kubernetes log aggregation. 
It indexes only metadata (labels like pod name, namespace, 
container) rather than the full log content, which makes it 
significantly cheaper on memory and storage. Since Prometheus 
and Grafana are already part of the stack, adding Loki means 
logs and metrics are queryable in the same Grafana UI — no 
need to switch between tools. The ELK stack is powerful but 
resource-heavy: Elasticsearch alone needs gigabytes of RAM 
to run well.

## Tradeoffs
Loki is not a full-text search engine. If you need to search 
across log content efficiently at large scale, Elasticsearch 
is significantly more capable. Loki's LogQL query language 
is also less mature than Elasticsearch's query DSL. For a 
platform running at the scale of this project, Loki's 
tradeoffs are acceptable.
