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
