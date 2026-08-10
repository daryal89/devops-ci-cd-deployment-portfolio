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
