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

### Planned

- Node.js and Express application
- Automated linting and testing
- Docker containerization
- GitHub Actions CI/CD
- GitHub Container Registry publishing
- Cloud deployment
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
