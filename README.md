# DevOps CI/CD Deployment Portfolio

A production-style DevOps portfolio project demonstrating the software delivery lifecycle for a small Node.js and Express web API.

> **Project Status:** In development — Phase 1 repository initialization.

## Project Objective

This project demonstrates practical DevOps skills through source control, automated testing, containerization, continuous integration, container-image publishing, cloud deployment, security practices, troubleshooting, validation, and release management.

## Planned Application Endpoints

- `GET /`
- `GET /health`
- `GET /version`
- `GET /api/status`

These endpoints will provide application availability, health, environment, version, status, and build information.

## Planned Technology Stack

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
| Repository initialization | In progress |
| Node.js / Express application | Not started |
| Automated testing | Not started |
| Docker containerization | Not started |
| GitHub Actions CI | Not started |
| Container registry publishing | Not started |
| Cloud deployment | Not started |
| Release v1.0.0 | Not started |

## Security Principles

- No real secrets committed to Git
- Local environment files excluded through `.gitignore`
- Safe example configuration stored in `.env.example`
- Credentials will use approved secret-management mechanisms
- Screenshots will be reviewed before publication
- Security checks will be incorporated into CI/CD

## Documentation

Detailed documentation will be added as each project phase is implemented and verified.

## License

This project is licensed under the MIT License. See `LICENSE` for details.
