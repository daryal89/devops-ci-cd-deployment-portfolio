# DevOps CI/CD Deployment Portfolio

A production-style DevOps portfolio project demonstrating the software delivery lifecycle for a small Node.js and Express web API.

> **Project Status:** Production release v1.0.0 completed and verified. CI/CD, deployment, smoke testing, troubleshooting, rollback, and recovery workflows are fully implemented.

**Live Production:** https://ca-devops-portfolio-api.politedune-2cb686dc.eastus2.azurecontainerapps.io

## Project Objective

This project demonstrates practical DevOps skills through source control, automated testing, containerization, continuous integration, container-image publishing, cloud deployment, security practices, troubleshooting, validation, and release management.

## Application Endpoints

- `GET /`
- `GET /health`
- `GET /version`
- `GET /api/status`

These endpoints provide application availability, health, environment, version, status, and build information.

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

## DevOps Workflow

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
| Continuous deployment | Completed |
| Post-deployment smoke testing | Completed |
| Production troubleshooting & rollback | Completed |
| v1.0.0 production release | Completed |

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

### Phase 8 - Continuous Deployment to Azure

Phase 8 extends the verified CI, GHCR publishing, and Azure Container Apps foundation into a controlled continuous deployment workflow from the protected `main` branch.

The deployment workflow:

- Keeps pull requests validation-only and prevents PRs from publishing container images or deploying to Azure
- Detects release-relevant changes before allowing deployment work to proceed
- Publishes an immutable GHCR image tagged with the source commit SHA
- Deploys the verified image to Azure Container Apps only after successful CI validation
- Uses source-commit-derived deployment identity for end-to-end traceability
- Sets the Azure Container App `BUILD_ID` to the deployed immutable image identifier
- Creates a revision name derived from the source commit
- Verifies the deployed `BUILD_ID` and container image after deployment
- Uses the Azure revision state to confirm the production revision is active, healthy, provisioned, and receiving 100% of traffic

A deployment-verification quoting defect was identified after the initial Phase 8 deployment. The Azure deployment itself had completed successfully, but the JMESPath verification query failed because of invalid escaped quoting.

The defect was corrected through a dedicated hotfix branch and pull request:

- Hotfix branch: `fix/phase-8-deployment-verification`
- Pull request: `#10`
- Only `.github/workflows/ci.yml` was changed
- Hotfix contained one logical line replacement
- Pull-request CI checks passed before merge
- The hotfix was squash-merged into `main`
- The subsequent `main` workflow completed successfully through `Deploy to Azure`
- The temporary local and remote hotfix branches were removed after production verification

Final verified production identity:

- Main commit: `1454909c4d2881cdf0ace2c9b179cecc5615dc14`
- Azure `BUILD_ID`: `sha-1454909`
- Container image: `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-1454909`
- Active revision: `ca-devops-portfolio-api--cd-1454909`
- Traffic weight: `100%`
- Health state: `Healthy`
- Provisioning state: `Provisioned`

#### Phase 8 Evidence

- [Pull-request deployment security gate](screenshots/phase-08-continuous-deployment/01-pr-deployment-gate.png)
- [Successful production CI/CD workflow](screenshots/phase-08-continuous-deployment/02-github-actions-production-success.png)
- [Merged deployment-verification hotfix PR](screenshots/phase-08-continuous-deployment/03-hotfix-pr-10-merged.png)
- [Azure BUILD_ID and immutable deployed image](screenshots/phase-08-continuous-deployment/04-azure-build-id-and-image.png)
- [Healthy active Azure production revision](screenshots/phase-08-continuous-deployment/05-azure-active-revision.png)
- [Final synchronized main repository state](screenshots/phase-08-continuous-deployment/06-final-main-repository-state.png)
- [Documentation-only deployment gate](screenshots/phase-08-continuous-deployment/07-docs-only-deployment-gate.png)

### Phase 9 - Post-Deployment Smoke Tests and Monitoring Fundamentals

Phase 9 extends the production CI/CD pipeline with automated runtime validation after every approved production deployment.

The post-deployment validation workflow:

- Runs only after a successful production deployment from `main`
- Executes as a separate `Post-Deployment Smoke Tests` GitHub Actions job
- Dynamically obtains the deployed Azure Container App public URL
- Uses the immutable deployment `BUILD_ID` produced by the deployment job
- Requires no Azure credentials or OIDC permissions in the smoke-test job
- Uses only read-only repository permissions
- Includes retry handling for newly deployed revisions
- Validates both HTTP availability and expected application response contracts
- Fails closed when the deployed runtime identity does not match the expected build

The automated production smoke test validates:

- `/` returns HTTP 200 and reports `status: running`
- `/health` returns HTTP 200 and reports `status: healthy`
- `/version` returns HTTP 200 and the expected deployed `BUILD_ID`
- `/api/status` returns HTTP 200 and reports `status: operational`
- `/api/status` reports the `production` environment
- `/api/status` returns the expected deployed `BUILD_ID`

The reusable smoke-test implementation is stored at:

- `scripts/post-deployment-smoke-test.sh`

The script was verified with both positive and negative testing before CI integration. A deliberately incorrect BUILD_ID was correctly rejected with a non-zero exit code, proving the deployment validation gate fails when runtime identity is incorrect.

Pull-request security behavior was also verified:

- Application Quality runs on pull requests
- Docker Build runs on pull requests
- Publish Container Image is skipped
- Deploy to Azure is skipped
- Post-Deployment Smoke Tests is skipped

The successful Phase 9 production workflow deployed and validated:

- Main commit: `9c386e0f98ccdb128248b87d7cbd4d1986eac83f`
- Azure `BUILD_ID`: `sha-9c386e0`
- Container image: `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0`
- Active revision: `ca-devops-portfolio-api--cd-9c386e0`
- Traffic weight: `100%`
- Health state: `Healthy`
- Provisioning state: `Provisioned`

Azure Container Apps logging fundamentals were also verified. Container console logs were accessible and confirmed the Node application was running, while system logs exposed production revision lifecycle events including replica creation, image pulling, container creation, and container startup.

#### Phase 9 Evidence

- [Pull-request smoke-test security gate](screenshots/phase-09-post-deployment-smoke-tests/01-pr-smoke-test-security-gate.png)
- [Successful production CI/CD and smoke-test workflow](screenshots/phase-09-post-deployment-smoke-tests/02-production-smoke-test-workflow-success.png)
- [Automated production smoke-test results](screenshots/phase-09-post-deployment-smoke-tests/03-production-smoke-test-results.png)
- [Verified production deployment identity](screenshots/phase-09-post-deployment-smoke-tests/04-production-deployment-identity.png)
- [Azure Container Apps system logs accessible](screenshots/phase-09-post-deployment-smoke-tests/05-azure-system-logs-accessible.png)
- [Final synchronized main repository state](screenshots/phase-09-post-deployment-smoke-tests/06-final-main-repository-state.png)

---

## Phase 10 — Production Failure Simulation, Troubleshooting, Rollback & Recovery

Phase 10 extends the CI/CD portfolio beyond successful deployment by demonstrating a complete controlled production incident lifecycle: failure detection, runtime diagnosis, emergency rollback, permanent source remediation, and verified recovery.

### Business Purpose

Production deployment success does not always mean the released application is functionally correct. Phase 10 demonstrates how layered validation, immutable artifacts, deployment identity, and post-deployment smoke tests reduce release risk and support rapid recovery.

The exercise intentionally introduced a production-only `/api/status` contract defect while leaving the application health endpoint operational.

This created a realistic failure condition in which:

- Application Quality passed
- Docker Build passed
- container image publishing passed
- Azure deployment passed
- Azure reported the revision as `Healthy`
- Azure reported the revision as `Provisioned`
- production traffic remained at `100%`
- `/health` returned HTTP 200
- Post-Deployment Smoke Tests still detected incorrect application behavior

### Controlled Failure

Controlled-failure pull request: **PR #12**

Controlled-failure main commit: `be308107bdaa1705d4d71c8f13e8ee523c18a7b2`

Defective deployment identity:

- BUILD_ID: `sha-be30810`
- Image: `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-be30810`
- Revision: `ca-devops-portfolio-api--cd-be30810`

The defective `/api/status` endpoint returned HTTP 200 but reported:

- expected environment: `production`
- actual environment: `staging`

The post-deployment smoke-test gate correctly rejected the release.

### Production Failure Pattern

The controlled production workflow demonstrated:

- Release Change Detection — success
- Application Quality — success
- Docker Build — success
- Publish Container Image — success
- Deploy to Azure — success
- Post-Deployment Smoke Tests — **failure**

This demonstrated that deployment success and infrastructure health are not equivalent to application correctness.

### Emergency Rollback

Before the exercise began, the previously verified immutable production image `sha-9c386e0` was confirmed to still be available.

The failed deployment was rolled back to:

- BUILD_ID: `sha-9c386e0`
- Image: `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0`
- Revision: `ca-devops-portfolio-api--rollback-9c386e0`

Recovery verification confirmed:

- rollback revision active
- `100%` production traffic
- HealthState `Healthy`
- ProvisioningState `Provisioned`
- `/` passed
- `/health` passed
- `/version` passed
- `/api/status` restored `environment: production`
- full production smoke-test suite passed

### Permanent Source Remediation

Emergency rollback restored production, but the defective source still existed on `main`.

A dedicated remediation branch and **PR #13** restored the correct application contract.

The corrected source was validated with:

- ESLint
- all automated tests
- Docker build
- production-style local Docker execution
- direct `/api/status` validation
- the real post-deployment smoke-test script

PR #13 was then squash-merged and triggered a fresh production deployment.

Final corrected production identity:

- Main commit: `740dfade8c3e9bd8dc64e5bc6012221d983df221`
- BUILD_ID: `sha-740dfad`
- Image: `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-740dfad`
- Revision: `ca-devops-portfolio-api--cd-740dfad`

### Final Production Result

The final corrected production workflow completed all six jobs successfully:

- Release Change Detection — success
- Application Quality — success
- Docker Build — success
- Publish Container Image — success
- Deploy to Azure — success
- Post-Deployment Smoke Tests — success

Final runtime verification confirmed:

- Active revision
- `100%` production traffic
- HealthState `Healthy`
- ProvisioningState `Provisioned`
- `/` passed
- `/health` passed
- `/version` reported `sha-740dfad`
- `/api/status` reported `environment: production`
- final post-deployment smoke test passed

### Operational Documentation

Detailed operational documentation:

- [Production Troubleshooting Guide](docs/troubleshooting.md)
- [Production Rollback Guide](docs/rollback.md)

### Phase 10 Evidence

- [Controlled production smoke-test failure](screenshots/phase-10-failure-troubleshooting-rollback/01-controlled-production-smoke-test-failure.png)
- [Exact smoke-test failure details](screenshots/phase-10-failure-troubleshooting-rollback/02-smoke-test-failure-details.png)
- [Healthy but defective production identity](screenshots/phase-10-failure-troubleshooting-rollback/03-defective-production-identity.png)
- [Emergency rollback success](screenshots/phase-10-failure-troubleshooting-rollback/04-emergency-rollback-success.png)
- [Source remediation production success](screenshots/phase-10-failure-troubleshooting-rollback/05-source-remediation-production-success.png)
- [Final synchronized main repository state](screenshots/phase-10-failure-troubleshooting-rollback/06-final-main-repository-state.png)

### Skills Demonstrated

Phase 10 provides practical evidence of:

- production incident detection
- post-deployment validation
- application contract testing
- Git-to-runtime deployment traceability
- immutable container image rollback
- Azure Container Apps revision inspection
- runtime BUILD_ID verification
- structured root-cause analysis
- emergency production recovery
- source remediation through pull requests
- end-to-end recovery verification
- operational troubleshooting and rollback documentation

**Phase 10 Status:** Completed and verified.
