# Project Evidence Screenshots

This directory contains selected screenshots that provide visual evidence of verified milestones completed during the DevOps CI/CD Deployment Portfolio project.

Only screenshots that have been reviewed for relevance, readability, and sensitive-information exposure are included.

## Phase 0 — Environment Audit

### 01 — Environment Audit

**File:** [`phase-00-audit/01-environment-audit.png`](phase-00-audit/01-environment-audit.png)

Demonstrates the verified local development environment, including:

- Git
- Node.js
- npm
- Visual Studio Code
- WSL2
- Ubuntu

**Status:** Verified

### 02 — Docker Prerequisite Audit

**File:** [`phase-00-audit/02-docker-prerequisite-audit.png`](phase-00-audit/02-docker-prerequisite-audit.png)

Documents the initial Docker prerequisite assessment:

- Docker Desktop was not installed
- Docker CLI was not available
- Docker Compose was not available
- WSL2 and Ubuntu were available for future Docker Desktop integration

**Status:** Verified

## Phase 1 — Repository Setup

### 01 — GitHub Repository Created

**File:** [`phase-01-repository-setup/01-repository-created.png`](phase-01-repository-setup/01-repository-created.png)

Demonstrates:

- Public GitHub repository creation
- Stable `main` branch
- Initial repository foundation files
- Initial Git commit
- Rendered project README
- MIT License recognition

**Status:** Verified

## Evidence Policy

Screenshots included in this repository must not expose:

- Passwords
- Authentication tokens
- API keys
- Secret values
- Private environment variables
- Billing information
- Unnecessary personal information
- Unrelated browser tabs or notifications

Additional evidence will be added only after the corresponding project milestone has been completed and verified.

### 02 — Pull Request Review

**File:** [`phase-01-repository-setup/02-pull-request-review.png`](phase-01-repository-setup/02-pull-request-review.png)

Demonstrates:

- Open pull request from `chore/phase-1-repository-setup` into `main`
- One feature-branch commit
- Six files changed
- Documented verification and security review
- No merge conflicts with the base branch
- Manual review performed before merge

**Status:** Verified

## Phase 2 — Minimal Express Application

### 01 — Local API Running

**File:** [`phase-02-application/01-local-api-running.png`](phase-02-application/01-local-api-running.png)

Demonstrates:

- Local Node.js and Express API running successfully
- `GET /` returning HTTP `200 OK`
- JSON response confirming application status
- `X-Powered-By` response header disabled

**Status:** Verified

### 02 — Graceful Shutdown

**File:** [`phase-02-application/02-graceful-shutdown.png`](phase-02-application/02-graceful-shutdown.png)

Demonstrates:

- Application listening on port `3000`
- `SIGINT` shutdown signal handling
- Graceful HTTP server shutdown
- Clean server termination

**Status:** Verified

### 03 — Phase 2 Pull Request Review

**File:** [`phase-02-application/03-phase-2-pull-request-review.png`](phase-02-application/03-phase-2-pull-request-review.png)

Demonstrates:

- Open Phase 2 pull request from `feat/phase-2-express-api` into `main`
- One feature-branch commit
- Nine files changed
- Documented verification and security review
- Manual pull request review before merge
- No conflicts with the base branch
- Pull request ready to merge

**Status:** Verified

## Phase 3 — Testing, Linting, and Operational Endpoints

### 01 — All Endpoints Working

**File:** [`phase-03-quality/01-all-endpoints-working.png`](phase-03-quality/01-all-endpoints-working.png)

Demonstrates:

- `GET /` returning HTTP `200`
- `GET /health` returning HTTP `200`
- `GET /version` returning HTTP `200`
- `GET /api/status` returning HTTP `200`
- Unknown route returning structured HTTP `404`
- JSON responses for application status, health, version, build, and runtime information

**Status:** Verified

### 02 — Quality Checks Passing

**File:** [`phase-03-quality/02-quality-checks-passing.png`](phase-03-quality/02-quality-checks-passing.png)

Demonstrates:

- Node.js runtime version
- ESLint quality check passing
- Five automated endpoint tests passing
- Zero automated test failures
- Dependency security audit reporting zero vulnerabilities
- JavaScript syntax validation passing
- Git whitespace check passing

**Status:** Verified

### 03 — Phase 3 Pull Request Review

**File:** [`phase-03-quality/03-phase-3-pull-request-review.png`](phase-03-quality/03-phase-3-pull-request-review.png)

Demonstrates:

- Open Phase 3 pull request from `feat/phase-3-testing-health-endpoints` into `main`
- One feature-branch commit
- Ten files changed
- Automated testing and linting scope documented
- Verification and security review documented
- Pull request confirmed ready to merge
- Manual review performed before merge

**Status:** Verified

## Phase 4 — Docker Containerization

### 01 — Docker Image Security

**File:** [`phase-04-docker/01-docker-image-security.png`](phase-04-docker/01-docker-image-security.png)

Demonstrates:

- Production Docker image configuration
- Non-root `node` runtime user
- Application working directory `/app`
- Application source files included in the runtime image
- Production dependency installation
- Development dependencies excluded
- `NODE_ENV=production`
- Container port `3000`

**Status:** Verified

### 02 — Docker Endpoints Working

**File:** [`phase-04-docker/02-docker-endpoints-working.png`](phase-04-docker/02-docker-endpoints-working.png)

Demonstrates:

- Containerized `GET /` returning HTTP `200`
- Containerized `GET /health` returning HTTP `200`
- Containerized `GET /version` returning HTTP `200`
- Containerized `GET /api/status` returning HTTP `200`
- Unknown route returning structured HTTP `404`
- Docker runtime environment reported as `production`
- Docker build identifier returned as `docker-local`
- `X-Powered-By` header remains disabled

**Status:** Verified

### 03 — Docker Health and Lifecycle

**File:** [`phase-04-docker/03-docker-health-lifecycle.png`](phase-04-docker/03-docker-health-lifecycle.png)

Demonstrates:

- Docker container health status reported as `healthy`
- Repeated successful health-check exit codes
- `/health` returning HTTP `200`
- Docker graceful stop behavior
- Application receiving `SIGTERM`
- HTTP server shutting down cleanly
- Container exiting successfully with exit code `0`

**Status:** Verified

### 04 — Phase 4 Pull Request Review

**File:** [`phase-04-docker/04-phase-4-pull-request-review.png`](phase-04-docker/04-phase-4-pull-request-review.png)

Demonstrates:

- Open Phase 4 pull request from `feat/phase-4-docker-containerization` into `main`
- One feature-branch commit
- Eight files changed
- Docker containerization scope documented
- Docker verification and lifecycle validation documented
- Containerized endpoint verification documented
- Pull request confirmed ready to merge
- Manual pull request review performed before merge

**Status:** Verified

## Phase 5 — GitHub Actions Continuous Integration

### 01 — Phase 5 Pull Request Overview

**File:** [`phase-05-github-actions-ci/01-phase-5-pull-request-overview.png`](phase-05-github-actions-ci/01-phase-5-pull-request-overview.png)

Demonstrates:

- Open Phase 5 pull request from `feat/phase-5-github-actions-ci` into `main`
- Two feature-branch commits included in the pull request
- Initial GitHub Actions continuous integration scope documented
- Application-quality and Docker-build validation responsibilities documented
- Read-only repository permissions documented
- Blocking CI quality, security, and build gates documented
- Local pre-publish validation results documented
- Pull request confirmed ready to merge after successful validation

**Status:** Verified

### 02 — Application Quality Job Passed

**File:** [`phase-05-github-actions-ci/02-application-quality-job-passed.png`](phase-05-github-actions-ci/02-application-quality-job-passed.png)

Demonstrates:

- GitHub Actions `Application Quality` job completed successfully
- Repository checkout completed successfully
- Node.js 24 environment configured successfully
- npm dependencies installed successfully
- ESLint quality validation passed
- Automated API test suite passed
- npm dependency security audit passed
- All application-quality CI steps completed without failure
- `Docker Build` job also reported successful in the workflow run

**Status:** Verified

### 03 — Docker Build and CI Checks Passed

**File:** [`phase-05-github-actions-ci/03-docker-build-ci-checks-passed.png`](phase-05-github-actions-ci/03-docker-build-ci-checks-passed.png)

Demonstrates:

- GitHub Actions CI workflow completed successfully
- `Application Quality` job passed
- `Docker Build` job passed
- Docker runtime verification completed successfully
- Dockerfile validation completed successfully
- Application Docker image built successfully
- All Docker CI job steps completed without failure
- Both independent CI jobs reached a successful final state

**Status:** Verified

## Phase 6 — GitHub Container Registry Publishing

### 01 — Pull Request Publication Gate

**File:** [`phase-06-ghcr-publishing/01-pr-publication-gate.png`](phase-06-ghcr-publishing/01-pr-publication-gate.png)

Demonstrates:

- GitHub Actions workflow triggered by a pull request targeting `main`
- `Application Quality` completed successfully
- `Docker Build` completed successfully
- `Publish Container Image` was intentionally skipped
- Container publication is prevented during pull-request validation
- Publishing remains gated behind successful validation and a push to `main`
- Pull-request CI completed successfully without creating a GHCR package

**Status:** Verified

### 02 — Main GHCR Publication Succeeded

**File:** [`phase-06-ghcr-publishing/02-main-ghcr-publish-success.png`](phase-06-ghcr-publishing/02-main-ghcr-publish-success.png)

Demonstrates:

- GitHub Actions workflow triggered by a push to `main`
- `Application Quality` completed successfully
- `Docker Build` completed successfully
- `Publish Container Image` completed successfully
- Container publishing occurred only after both validation jobs succeeded
- The post-merge workflow completed successfully
- Docker build output was produced during the publication workflow

**Status:** Verified

### 03 — GHCR Package and Traceability Tags

**File:** [`phase-06-ghcr-publishing/03-ghcr-package-tags.png`](phase-06-ghcr-publishing/03-ghcr-package-tags.png)

Demonstrates:

- Published GHCR package `devops-ci-cd-deployment-portfolio`
- Public container-package availability
- Published `main` tag for the latest verified `main` image
- Published `sha-fcb6e50` tag for source-commit traceability
- GHCR pull command for the published container image
- Package association with the source repository
- Successful creation of a tagged container artifact in GitHub Container Registry

**Status:** Verified

### 04 — GHCR Pull and Runtime Verification

**File:** [`phase-06-ghcr-publishing/04-ghcr-pull-runtime-verification.png`](phase-06-ghcr-publishing/04-ghcr-pull-runtime-verification.png)

Demonstrates:

- Local GHCR image absence verified before the registry pull
- Public `main` image pulled directly from GitHub Container Registry
- Published image SHA-256 digest verified
- Container configured to execute as the non-root `node` user
- Application working directory verified as `/app`
- Published container reached Docker `healthy` status
- `/health` endpoint returned `{"status":"healthy"}`
- Runtime identity verified as `uid=1000(node)`
- Published GHCR container remained running and healthy after startup

**Status:** Verified

## Phase 7 — Azure Container Apps Cloud Deployment

### 01 — Azure Container App Overview

**File:** [`phase-07-cloud-deployment/01-azure-container-app-overview.png`](phase-07-cloud-deployment/01-azure-container-app-overview.png)

Demonstrates:

- Azure Container App `ca-devops-portfolio-api`
- Running application status in East US 2
- `rg-devops-portfolio-prod` resource group
- `cae-devops-portfolio-prod` Container Apps environment
- Consumption-only environment
- Public Azure application URL
- Production/project resource tags

**Status:** Verified

### 02 — Public Cloud Endpoints Working

**File:** [`phase-07-cloud-deployment/02-public-cloud-endpoints-working.png`](phase-07-cloud-deployment/02-public-cloud-endpoints-working.png)

Demonstrates:

- Public Azure HTTPS application endpoint
- `/` returning HTTP 200
- `/health` returning HTTP 200
- `/version` returning HTTP 200
- `/api/status` returning HTTP 200
- Production environment response
- Runtime build traceability through `sha-ea30b66`

**Status:** Verified

### 03 — Health and Revision Validation

**File:** [`phase-07-cloud-deployment/03-health-revision-validation.png`](phase-07-cloud-deployment/03-health-revision-validation.png)

Demonstrates:

- Azure Container Apps single revision mode
- Active `health-ea30b66` revision
- Healthy and provisioned revision state
- 100% traffic routed to the latest revision
- Explicit startup, liveness, and readiness probes
- `/health` probe target on port `3000`
- Immutable GHCR image `sha-ea30b66`
- `0.25` vCPU and `0.5Gi` memory
- Scale-to-zero configuration with `0–1` replicas

**Status:** Verified

### 04 — Azure Live Logs

**File:** [`phase-07-cloud-deployment/04-azure-live-logs.png`](phase-07-cloud-deployment/04-azure-live-logs.png)

Demonstrates:

- Azure Container Apps system log access
- Azure platform container and scaling lifecycle events
- Application console log access
- Successful connection to the active container
- Node API listening on port `3000`
- Public `/health` verification returning HTTP 200 after log inspection
- Active revision traceability through `health-ea30b66`

**Status:** Verified

## Phase 8 - Continuous Deployment to Azure

### 01 - Pull Request Deployment Security Gate

**File:** [`phase-08-continuous-deployment/01-pr-deployment-gate.png`](phase-08-continuous-deployment/01-pr-deployment-gate.png)

Demonstrates:

- Phase 8 pull request validation before production deployment
- Pull request targeting `main`
- Release Change Detection completed successfully
- Application Quality completed successfully
- Docker Build completed successfully
- Publish Container Image intentionally skipped for the pull-request event
- Deploy to Azure intentionally skipped for the pull-request event
- Release-relevant workflow change correctly detected
- Pull requests cannot publish production images or deploy to Azure
- Clean local repository state after deployment-gate verification

**Status:** Verified

### 02 - Successful Production CI/CD Workflow

**File:** [`phase-08-continuous-deployment/02-github-actions-production-success.png`](phase-08-continuous-deployment/02-github-actions-production-success.png)

Demonstrates:

- GitHub Actions workflow triggered by a `push` to `main`
- Production commit `1454909`
- Release Change Detection completed successfully
- Application Quality completed successfully
- Docker Build completed successfully
- Publish Container Image completed successfully
- Deploy to Azure completed successfully
- Complete CI/CD dependency graph executed successfully
- End-to-end production deployment completed with all required jobs passing

**Status:** Verified

### 03 - Deployment Verification Hotfix Pull Request

**File:** [`phase-08-continuous-deployment/03-hotfix-pr-10-merged.png`](phase-08-continuous-deployment/03-hotfix-pr-10-merged.png)

Demonstrates:

- Dedicated hotfix pull request `#10`
- Hotfix branch `fix/phase-8-deployment-verification`
- Root cause documented as invalid JMESPath quoting
- Azure deployment itself had succeeded before the verification defect was corrected
- Only the deployment `BUILD_ID` verification query was changed
- One commit and one file changed
- Five pull-request checks passed
- Hotfix successfully merged into `main`
- Controlled defect remediation through the pull-request workflow

**Status:** Verified

### 04 - Azure Production Deployment Identity

**File:** [`phase-08-continuous-deployment/04-azure-build-id-and-image.png`](phase-08-continuous-deployment/04-azure-build-id-and-image.png)

Demonstrates:

- Current repository branch is `main`
- Main commit `1454909c4d2881cdf0ace2c9b179cecc5615dc14`
- Azure Container App `BUILD_ID` is `sha-1454909`
- Deployed GHCR image is `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-1454909`
- Source commit, runtime build identity, and immutable container image tag match
- End-to-end deployment traceability from Git commit to Azure runtime

**Status:** Verified

### 05 - Azure Active Revision Health

**File:** [`phase-08-continuous-deployment/05-azure-active-revision.png`](phase-08-continuous-deployment/05-azure-active-revision.png)

Demonstrates:

- Active Azure Container Apps revision `ca-devops-portfolio-api--cd-1454909`
- Revision is active
- Production traffic weight is `100%`
- Health state is `Healthy`
- Provisioning state is `Provisioned`
- Revision identity matches the deployed source commit
- Production revision successfully received the deployment

**Status:** Verified

### 06 - Final Main Repository State

**File:** [`phase-08-continuous-deployment/06-final-main-repository-state.png`](phase-08-continuous-deployment/06-final-main-repository-state.png)

Demonstrates:

- Final repository branch is `main`
- Local `main` SHA is `1454909c4d2881cdf0ace2c9b179cecc5615dc14`
- `origin/main` has the identical commit SHA
- Local repository is synchronized with the remote
- Working tree is clean
- Phase 8 hotfix and production verification concluded from a stable repository state

**Status:** Verified

### 07 - Documentation-Only Deployment Gate

**File:** [`phase-08-continuous-deployment/07-docs-only-deployment-gate.png`](phase-08-continuous-deployment/07-docs-only-deployment-gate.png)

Demonstrates:

- GitHub Actions workflow triggered by a documentation-only `push` to `main`
- Release Change Detection completed successfully
- Application Quality completed successfully
- Docker Build completed successfully
- Publish Container Image was intentionally skipped
- Deploy to Azure was intentionally skipped
- Documentation and screenshot changes do not create unnecessary production images
- Documentation-only changes do not trigger unnecessary Azure deployments
- Release-change gating reduces deployment risk and unnecessary cloud activity
- Workflow completed successfully while preserving the existing production deployment

**Status:** Verified

## Phase 9 - Post-Deployment Smoke Tests and Monitoring Fundamentals

### 01 - Pull Request Smoke-Test Security Gate

**File:** [`phase-09-post-deployment-smoke-tests/01-pr-smoke-test-security-gate.png`](phase-09-post-deployment-smoke-tests/01-pr-smoke-test-security-gate.png)

Demonstrates:

- Phase 9 pull-request workflow validation
- Release Change Detection completed successfully
- Application Quality completed successfully
- Docker Build completed successfully
- Publish Container Image intentionally skipped
- Deploy to Azure intentionally skipped
- Post-Deployment Smoke Tests intentionally skipped
- Pull requests cannot publish, deploy, or execute production smoke tests

**Status:** Verified

### 02 - Successful Production CI/CD and Smoke-Test Workflow

**File:** [`phase-09-post-deployment-smoke-tests/02-production-smoke-test-workflow-success.png`](phase-09-post-deployment-smoke-tests/02-production-smoke-test-workflow-success.png)

Demonstrates:

- GitHub Actions workflow triggered by a `push` to `main`
- Release Change Detection succeeded
- Application Quality succeeded
- Docker Build succeeded
- Publish Container Image succeeded
- Deploy to Azure succeeded
- Post-Deployment Smoke Tests succeeded
- Production workflow dependency chain completed end-to-end
- Runtime validation occurred only after successful deployment

**Status:** Verified

### 03 - Automated Production Smoke-Test Results

**File:** [`phase-09-post-deployment-smoke-tests/03-production-smoke-test-results.png`](phase-09-post-deployment-smoke-tests/03-production-smoke-test-results.png)

Demonstrates:

- Dedicated `Post-Deployment Smoke Tests` GitHub Actions job
- Dynamically resolved Azure Container App URL
- Expected production BUILD_ID `sha-9c386e0`
- `/` returned HTTP 200 and passed its response contract
- `/health` returned HTTP 200 and passed its response contract
- `/version` returned HTTP 200 and matched the expected BUILD_ID
- `/api/status` returned HTTP 200
- `/api/status` confirmed operational production state
- `/api/status` matched the expected BUILD_ID
- Complete production smoke test passed

**Status:** Verified

### 04 - Verified Production Deployment Identity

**File:** [`phase-09-post-deployment-smoke-tests/04-production-deployment-identity.png`](phase-09-post-deployment-smoke-tests/04-production-deployment-identity.png)

Demonstrates:

- Azure BUILD_ID `sha-9c386e0`
- Immutable GHCR image `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0`
- Active Azure revision corresponding to source commit `9c386e0`
- Revision active state is `True`
- Production traffic weight is `100%`
- Health state is `Healthy`
- Provisioning state is `Provisioned`
- Git commit, image identity, runtime BUILD_ID, and Azure revision are traceable

**Status:** Verified

### 05 - Azure Container Apps System Logs Accessible

**File:** [`phase-09-post-deployment-smoke-tests/05-azure-system-logs-accessible.png`](phase-09-post-deployment-smoke-tests/05-azure-system-logs-accessible.png)

Demonstrates:

- Azure Container Apps system logs are accessible
- Production revision and replica lifecycle events are visible
- Replica creation is observable
- Container image pulling is observable
- Successful image pull is observable
- Container creation is observable
- Container startup is observable
- Production revision identity is traceable through Azure operational logs

**Status:** Verified

### 06 - Final Main Repository State

**File:** [`phase-09-post-deployment-smoke-tests/06-final-main-repository-state.png`](phase-09-post-deployment-smoke-tests/06-final-main-repository-state.png)

Demonstrates:

- Final repository branch is `main`
- Local `main` SHA is `9c386e0f98ccdb128248b87d7cbd4d1986eac83f`
- `origin/main` has the identical SHA
- Local repository is synchronized with the remote
- Working tree is clean
- Phase 9 feature branch cleanup was completed before final evidence packaging

**Status:** Verified
