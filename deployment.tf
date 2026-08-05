# EKS Deployment — Multi-Service URL Shortener

## Overview

This README defines the deployment lifecycle for migrating a multi-service URL shortener system from ECS Fargate to Amazon EKS. The lifecycle is structured into three iterative phases — **Dev → Staging → Prod** — each building on the previous to deliver a controlled, observable, production-ready Kubernetes environment.

This guide focuses on the Kubernetes layer: workloads, access control, Helm packaging, GitOps, and observability. Underlying infrastructure provisioning (VPC, EKS cluster, IAM, RDS, Redis, SQS) is handled via Terraform.

---

## Phase 1 — Dev Environment

### Objective

Establish a functional EKS environment capable of running the API, Dashboard, and Worker services end-to-end with correct IAM permissions and stable infrastructure.

### Infrastructure Components

- **VPC** — public/private subnets, NAT gateways, isolated networking
- **EKS Cluster** — managed control plane
- **Node Group (Static)** — fixed compute capacity for development
- **RDS (PostgreSQL)** — primary data store
- **Redis** — caching layer for fast URL resolution
- **SQS** — asynchronous event queue for analytics
- **Bastion Host** — controlled access to private resources
- **Classic Load Balancer** — fronts the nginx ingress controller

### Access & Security

- **IAM Roles per Service** — least-privilege access boundaries
- **OIDC Provider** — enables IRSA
- **IRSA Bindings** — API, Dashboard, and Worker assume IAM roles via service accounts
- **Secrets Manager** — runtime retrieval of sensitive configuration
- **EKS Access Entries** — modern access control, replacing the legacy `aws-auth` ConfigMap

### Kubernetes Workloads

Three services deployed using raw manifests:

| Service   | Manifests |
|-----------|-----------|
| API       | deployment, service, ingress, configmap, serviceaccount |
| Dashboard | deployment, service, ingress, configmap, serviceaccount |
| Worker    | deployment, service, configmap |

### Helm Charts

| Chart | Purpose |
|-------|---------|
| cert-manager | Issues and manages TLS certificates via Let's Encrypt, providing secure TLS communication |
| ingress-nginx | Ingress controller for the load balancer; exposed as a `LoadBalancer`-type Service, fronting all in-cluster routing |

### Exit Criteria

- All services deployed and reachable
- IRSA functioning correctly
- Redis, RDS, SQS integrated
- Cluster stable under basic load
- No manual configuration drift

### Verification

- System reachable via the CLB CNAME with TLS enabled
- `kubectl get pods -A` (or per-namespace) shows all expected pods `Running` — API, Dashboard, Worker, and the ingress controller

---

## Phase 2 — Staging Environment

Dev lays the foundation, while Staging builds on top of it — adding the resources and automation needed to make the system robust, observable, and stable.

### Objective

- Package the workloads for configuration and reusability via Helm, enabling consistent deployments across environments with a structured, values-driven approach
- Secure entry-point access via an Application Load Balancer (ALB)
- Observability at the pod level via Prometheus and Grafana, with alerting

### Key Additions

**1. Helm Packaging**
- All Dev manifests packaged into a single parameterised Helm chart
- Raw YAML workloads converted into templates for each service, with values files for Dev / Staging / Prod
- Enables a dynamic, modular architecture for reusable configuration across environments

**2. Infrastructure (AWS)**
- Upgraded node instance types to support higher pod density (see [`TROUBLESHOOTING.md`](./TROUBLESHOOTING.md) — `t3.micro` caps at 4 pods/node)
- Set up and configured WAF on the ALB instance

**3. cert-manager + TLS**
- Automated certificate issuance via `ClusterIssuer`
- DNS configured with Cloudflare
- Ingress resources reference TLS secrets
- Removes manual certificate management

**4. Classic LB → Application Load Balancer**
- Installed the AWS Load Balancer Controller via Helm
- Configured new IRSA bindings so the ALB controller can connect with the nginx ingress
- ALB used as the internet-facing load balancer, with the nginx ingress controller handling routing behind it
- WAF integrated with the ALB

**5. Observability — Prometheus & Grafana**
- Prometheus deployed to scrape pod-level metrics
- Grafana dashboards for CPU and memory at the pod level
- Foundation for alerting ahead of Prod

### Exit Criteria

- Helm chart validated across Dev and Staging
- TLS fully automated
- CLB converted to ALB
- Prometheus scraping pod-level metrics; Grafana dashboards available
- Services scale under load without manual intervention

---

## Phase 3 — Production Environment

### Objective

Achieve full automation and operational maturity. Production becomes Git-driven, monitored, and self-correcting.

### Key Additions

**1. GitOps via ArgoCD**
- Git becomes the single source of truth
- Cluster continuously reconciles desired state
- Eliminates manual `kubectl`/`helm` commands against prod
- Enables safe rollbacks and auditability

**2. CloudWatch Dashboards**

Implemented for internal AWS services:

| Service | Metrics |
|---------|---------|
| RDS | CPU utilisation, memory |
| SQS | Queue depth, DLQ |
| ALB | Request count, error rates, response time |

### Exit Criteria

- GitOps fully operational
- CloudWatch dashboards available for all AWS-managed services
- Alerts configured for key failure conditions
- Production cluster stable under real traffic

---

## Deployment Flow Summary

Dev → Staging → Prod is not just environment separation it's an organised, structured maturity model that follows DRY principles throughout:

| Phase | Focus | Outcome |
|-------|-------|---------|
| Dev | Stand up workloads | Functional system with correct IAM + infra |
| Staging | Modularisation + automation + observability | Helm, TLS, Prometheus/Grafana monitoring |
| Prod | GitOps | Automated, production-grade cluster |

---

## Related Documentation

- `ARCHITECTURE.md` — detailed workload architecture