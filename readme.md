# URL-SHORTENER – EKS Multi Container Deployment

Secure platform for a multi-service container system on AWS. Originally deployed on ECS Fargate; this project converts it to Kubernetes workloads on EKS.

## Architecture

See [ARCHITECTURE.md](./ARCHITECTURE.md) for EKS/AWS infrastructure and Helm packaging details, including infrastructure and per-container diagrams.

## Services

| service | lang | resources |
|---|---|---|
| api | python | deployment, service, configmap, hpa |
| worker | go | deployment, configmap |
| dashboard | go | deployment, service, ingress |

## Docs

| Document | Covers |
|---|---|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | EKS/AWS infrastructure and Kubernetes Helm packaging, with diagrams |
| [DEPLOYMENT.md](./DEPLOYMENT.md) | Iterative phases of deployment |

## Links

- Live application: 
- Demo video: