# Changelog

All notable changes to this project will be documented in this file.

The project follows Semantic Versioning for release tags.

## [Unreleased]

### Added

- Initial repository structure
- Git line-ending normalization with `.gitattributes`
- Git ignore rules for dependencies, secrets, logs, build output, and local files
- Safe environment-variable template in `.env.example`
- Initial project README
- MIT License

### Phase 7 Azure Container Apps Cloud Deployment

- Added production-style cloud deployment using Azure Container Apps Consumption in East US 2.
- Created resource group `rg-devops-portfolio-prod`.
- Created Container Apps environment `cae-devops-portfolio-prod`.
- Deployed `ca-devops-portfolio-api` from immutable GHCR image `sha-ea30b66`.
- Configured external Azure-managed HTTPS ingress to application port `3000`.
- Configured `0.25` vCPU and `0.5Gi` memory.
- Configured minimum replicas `0` and maximum replicas `1`.
- Configured startup, liveness, and readiness HTTP probes against `/health` on port `3000`.
- Verified revision `health-ea30b66` as active, healthy, provisioned, and receiving 100% of ingress traffic.
- Verified public `/`, `/health`, `/version`, and `/api/status` endpoints.
- Verified runtime build traceability using `BUILD_ID=sha-ea30b66`.
- Verified Azure Container Apps system and application console log access.
- Kept persistent Log Analytics storage disabled.
- Verified no Log Analytics workspace was created.
- Verified no ACR, standalone public IP, load balancer, NAT gateway, or storage account was introduced.
- Captured four verified Phase 7 cloud deployment evidence screenshots.

### Planned

- Continuous deployment automation
- Post-deployment smoke testing
- Security scanning
- Rollback documentation
- Version `v1.0.0` release

### Documentation

- Added organized screenshot evidence directories
- Added Phase 0 environment audit evidence
- Added Phase 0 Docker prerequisite audit evidence
- Added Phase 1 GitHub repository creation evidence
- Added screenshot evidence index and privacy policy
- Linked project evidence from the main README

### Phase 2 Application

- Initialized the Node.js project configuration
- Added Express as the application dependency
- Added a minimal Express application in `src/app.js`
- Added server startup logic in `src/server.js`
- Added configurable `PORT` support with a default of `3000`
- Added JSON request parsing
- Disabled the default `X-Powered-By` response header
- Added `GET /` returning HTTP `200` with JSON application status
- Added graceful shutdown handling for `SIGINT` and `SIGTERM`
- Verified local API execution with `curl`
- Verified graceful shutdown behavior
- Added Phase 2 runtime evidence screenshots

### Phase 3 Quality and Operational Endpoints

- Added `GET /health` health-check endpoint
- Added `GET /version` with application version and build identifier
- Added `GET /api/status` with environment, version, build, and Node.js runtime information
- Added structured JSON `404` responses for unknown routes
- Added centralized application error-handling middleware
- Added ESLint configuration and `npm run lint`
- Added Supertest for API endpoint testing
- Added Node.js built-in automated test runner
- Added five automated endpoint tests
- Added `npm test` and `npm run check` quality scripts
- Verified all five automated tests pass with zero failures
- Verified ESLint passes with zero errors
- Verified dependency audit reports zero vulnerabilities
- Verified all operational endpoints locally
- Added Phase 3 endpoint and quality-check evidence screenshots

### Phase 4 Docker Containerization

- Installed and configured Docker Desktop with the WSL2 backend
- Enabled Docker integration with Ubuntu 24.04
- Verified Docker CLI, Docker Compose, Docker Engine, and `hello-world`
- Added `.dockerignore` to reduce build context and exclude sensitive/unnecessary files
- Added a production Dockerfile using Node.js 24 Alpine
- Added reproducible production dependency installation with `npm ci --omit=dev`
- Configured the container to run as the non-root `node` user
- Configured `NODE_ENV=production` and container port `3000`
- Added Docker health checking using the existing `/health` endpoint
- Built and inspected the local Docker image
- Verified development dependencies are excluded from the runtime image
- Verified all API endpoints through the running container
- Verified Docker-specific version, build, and production environment values
- Verified `X-Powered-By` remains disabled inside the container
- Verified Docker health status becomes `healthy`
- Verified container restart behavior and post-restart API availability
- Verified graceful `SIGTERM` handling and clean HTTP server shutdown
- Verified container exits successfully with exit code `0`
- Added Phase 4 Docker security, endpoint, health, and lifecycle evidence

### Phase 5 GitHub Actions Continuous Integration

- Added `.github/workflows/ci.yml` for automated continuous integration
- Configured CI to run for pull requests targeting `main`
- Configured CI to run for pushes to `main`
- Added read-only repository permissions with `contents: read`
- Added concurrency control to cancel obsolete workflow runs
- Added an independent `Application Quality` CI job
- Configured Node.js 24 with npm dependency caching
- Added reproducible dependency installation with `npm ci`
- Added blocking ESLint validation with `npm run lint`
- Added blocking automated API testing with `npm test`
- Added blocking dependency security auditing with `npm audit`
- Added an independent `Docker Build` CI job
- Added Docker runtime verification
- Added Dockerfile validation with `docker build --check .`
- Added automated Docker image build validation
- Updated `actions/checkout` and `actions/setup-node` to version 7
- Verified `Application Quality` passes successfully in GitHub Actions
- Verified `Docker Build` passes successfully in GitHub Actions
- Verified the Phase 5 pull request reaches a successful CI state with zero failing or pending checks
- Added Phase 5 pull request, application-quality, and Docker-build evidence screenshots

### Phase 6 GitHub Container Registry Publishing

- Extended `.github/workflows/ci.yml` with a gated `Publish Container Image` job
- Configured container publication to depend on both `Application Quality` and `Docker Build`
- Restricted container publishing to `push` events on the `main` branch
- Verified pull-request validation skips container publication
- Preserved global workflow permissions as `contents: read`
- Granted `packages: write` only to the container publishing job
- Configured GHCR authentication with the repository-provided `GITHUB_TOKEN`
- Configured GitHub Container Registry as the publishing destination
- Published container images to `ghcr.io/daryal89/devops-ci-cd-deployment-portfolio`
- Added `main` as the moving tag for the latest successfully published `main` image
- Added `sha-*` tags for source-commit traceability
- Intentionally omitted the Docker `latest` tag
- Added Docker Buildx support for container publishing
- Added Docker metadata generation for container tags and OCI labels
- Added automated Docker image build and registry push with `docker/build-push-action`
- Verified `Application Quality` and `Docker Build` succeed during pull-request validation
- Verified `Publish Container Image` is skipped during pull-request validation
- Verified no GHCR package is created by pull-request validation
- Verified all three workflow jobs succeed after merge to `main`
- Verified the public GHCR package is associated with the source repository
- Verified published `main` and `sha-*` image tags
- Verified the published image has a SHA-256 container digest
- Pulled the published `main` image directly from GHCR for independent runtime validation
- Verified the published container runs as the non-root `node` user
- Verified the published container reaches Docker `healthy` status
- Verified the published `/health` endpoint returns `{"status":"healthy"}`
- Added Phase 6 publication-gate, GHCR workflow, package-tag, and runtime evidence screenshots
