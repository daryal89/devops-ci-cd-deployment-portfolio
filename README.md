# DevOps CI/CD Deployment Portfolio

A production-style DevOps portfolio project demonstrating the software delivery lifecycle for a small Node.js and Express web API.

> **Project Status:** In development — Phase 5 GitHub Actions continuous integration implemented and verified.

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
| Container registry publishing | Not started |
| Cloud deployment | Not started |
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

## Security Principles

- No real secrets committed to Git
- Local environment files excluded through `.gitignore`
- Safe example configuration stored in `.env.example`
- Credentials will use approved secret-management mechanisms
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

See [`screenshots/README.md`](screenshots/README.md) for the complete evidence index and screenshot policy.
