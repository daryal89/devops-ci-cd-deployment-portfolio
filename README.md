# DevOps CI/CD Deployment Portfolio

A production-style DevOps portfolio project demonstrating the software delivery lifecycle for a small Node.js and Express web API.

> **Project Status:** In development — Phase 7 Azure Container Apps cloud deployment implemented and verified.

## Project Objective

This project demonstrates practical DevOps skills through source control, automated testing, containerization, continuous integration, container-image publishing, cloud deployment, security practices, troubleshooting, validation, and release management.

## Application Endpoints

- `GET /`
- `GET /health`
- `GET /version`
- `GET /api/status`

These endpoints will provide application availability, health, environment, version, status, and build information.

## Technology Stack

- Node.js
- Express
- npm
- Git and GitHub
- GitHub Actions
- Docker
- GitHub Container Registry
- Render
- WSL2 / Ubuntu
- Git Bash
- Visual Studio Code

## Planned DevOps Workflow

Developer → Feature Branch → Pull Request → GitHub Actions CI → Docker Image → GitHub Container Registry → Cloud Deployment → Smoke Tests

## Current Progress
| Area | Status |
| --- | --- |
| Environment audit | Completed |
| Repository initialization | Completed |
| Node.js / Express application | Completed |
| Automated testing and linting | Completed |
| Docker containerization | Completed |
| GitHub Actions CI | Completed |
| Container registry publishing | Completed |
| Cloud deployment | Completed |
| Continuous deployment | Not started |
| Release v1.0.0 | Not started |

## Continuous Integration

GitHub Actions provides automated validation for pull requests targeting `main` and for pushes to `main`.

The CI workflow uses two independent jobs:

### Application Quality

- Checks out the repository
- Configures Node.js 24 with npm dependency caching
- Installs dependencies reproducibly with `npm ci`
- Runs ESLint as a blocking quality gate
- Runs the automated API test suite
- Runs `npm audit` as a blocking dependency-security gate

### Docker Build

- Checks out the repository
- Verifies the Docker runtime
- Validates the Dockerfile with `docker build --check .`
- Builds the application Docker image

The workflow uses read-only repository permissions with `contents: read` and concurrency control to cancel obsolete workflow runs.

Phase 5 validation confirmed both `Application Quality` and `Docker Build` complete successfully with no failing or pending checks.

## Container Registry Publishing

Validated container images are published automatically to GitHub Container Registry (GHCR) after successful CI validation on `main`.

The publishing workflow:

- Depends on both `Application Quality` and `Docker Build`
- Runs only for `push` events on the `main` branch
- Skips container publication during pull-request validation
- Uses the repository-provided `GITHUB_TOKEN` for GHCR authentication
- Grants `packages: write` only to the publishing job
- Preserves global repository permissions as `contents: read`
- Publishes to `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio`
- Publishes a `main` tag for the latest successfully verified `main` image
- Publishes a `sha-*` tag for source-commit traceability
- Intentionally does not publish a Docker `latest` tag

The published image was independently pulled from GHCR and verified to:

- Run as the non-root `node` user
- Use `/app` as its working directory
- Reach Docker `healthy` status
- Return `{"status":"healthy"}` from `/health`
- Preserve a SHA-256 container-image digest

## Cloud Deployment

The verified application container is deployed to **Azure Container Apps** using the Consumption plan in **East US 2**.

- Resource group: `rg-devops-portfolio-prod`
- Container Apps environment: `cae-devops-portfolio-prod`
- Container App: `ca-devops-portfolio-api`
- Immutable deployment image: `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-ea30b66`
- The immutable `sha-*` image provides source-to-runtime traceability
- GHCR access uses a dedicated registry pull credential limited to `read:packages`; the credential is stored through Azure's secret-backed registry configuration and is not committed to Git
- Runtime allocation: `0.25` vCPU and `0.5Gi` memory
- Scaling is restricted to `0–1` replicas, allowing the Consumption workload to scale to zero when idle
- External Azure-managed HTTPS ingress forwards requests to application port `3000`
- Insecure HTTP access is disabled
- Explicit startup, liveness, and readiness probes call `/health` on port `3000`
- Single revision mode is enabled
- Revision `health-ea30b66` was verified as active, healthy, provisioned, and receiving 100% of ingress traffic
- Public `/`, `/health`, `/version`, and `/api/status` endpoints were verified successfully
- `/version` and `/api/status` report build ID `sha-ea30b66`
- Azure Container Apps system logs and application console logs were verified through Azure CLI
- Persistent Log Analytics storage is intentionally disabled for this low-traffic portfolio workload
- The Phase 7 resource group contains only the Container Apps environment and Container App
- No Azure Container Registry, standalone public IP, load balancer, NAT gateway, storage account, or Log Analytics workspace was introduced

## Security Principles

- No real secrets committed to Git
- Local environment files excluded through `.gitignore`
- Safe example configuration stored in `.env.example`
- GHCR authentication uses the repository-provided `GITHUB_TOKEN`
- Registry publishing receives `packages: write` only within the publishing job
- No Personal Access Token or custom registry credential is required for CI publishing
- Screenshots will be reviewed before publication
- Dependency security auditing is enforced in CI with `npm audit`
- Additional security scanning will be added in later phases

## Documentation

Project documentation and evidence are updated as each implementation phase is completed and verified. The repository includes milestone screenshots, validation results, and an indexed evidence trail for the implemented DevOps workflow.

## License

This project is licensed under the MIT License. See `LICENSE` for details.

## Project Evidence

Verified milestone screenshots are maintained in the [`screenshots/`](screenshots/) directory.

Current evidence includes:

- Phase 0 environment audit
- Phase 0 Docker prerequisite audit
- Phase 1 GitHub repository creation
- Phase 1 pull request review
- Phase 2 local API execution
- Phase 2 graceful shutdown
- Phase 3 operational endpoints
- Phase 3 automated tests and linting
- Phase 4 Docker image security verification
- Phase 4 containerized endpoint validation
- Phase 4 Docker health and lifecycle validation
- Phase 5 GitHub Actions pull request validation
- Phase 5 application-quality CI validation
- Phase 5 Docker-build CI validation
- Phase 6 pull-request container-publication gate validation
- Phase 6 successful GHCR publication from `main`
- Phase 6 GHCR package and image-tag verification
- Phase 6 published-image pull and runtime verification

See [`screenshots/README.md`](screenshots/README.md) for the complete evidence index and screenshot policy.

### Phase 7 — Azure Container Apps Cloud Deployment

- [Azure Container App overview](screenshots/phase-07-cloud-deployment/01-azure-container-app-overview.png)
- [Public cloud endpoints working](screenshots/phase-07-cloud-deployment/02-public-cloud-endpoints-working.png)
- [Health and revision validation](screenshots/phase-07-cloud-deployment/03-health-revision-validation.png)
- [Azure live logs](screenshots/phase-07-cloud-deployment/04-azure-live-logs.png)
