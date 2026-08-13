# Production Troubleshooting Guide

## DevOps CI/CD Deployment Portfolio — Phase 10

## Purpose

This document describes the controlled production failure, troubleshooting, emergency rollback, source remediation, and final recovery process demonstrated during Phase 10 of the DevOps CI/CD Deployment Portfolio.

Phase 10 intentionally introduced a production-only application response-contract defect in order to validate the complete operational incident lifecycle:

- controlled failure simulation
- local failure validation
- pull-request CI validation
- production deployment
- post-deployment failure detection
- production runtime inspection
- deployment identity verification
- root-cause analysis
- emergency rollback
- production recovery verification
- permanent source remediation
- recovery pull request
- corrected production deployment
- final smoke-test validation
- repository cleanup

The central operational lesson demonstrated by this exercise is:

> A deployment can be technically healthy, reachable, and successfully provisioned while the application is still functionally incorrect.

The exercise was deliberately controlled.

Before the defective change was allowed to reach production, a previously verified immutable container image was confirmed to be available as a deterministic rollback target.

---

## 1. Application and Deployment Context

The portfolio application is a Node.js and Express API deployed through GitHub Actions to Azure Container Apps.

The CI/CD workflow contains six primary jobs:

1. Release Change Detection
2. Application Quality
3. Docker Build
4. Publish Container Image
5. Deploy to Azure
6. Post-Deployment Smoke Tests

Container images are stored in GitHub Container Registry.

Production images use immutable Git SHA-derived tags.

Example:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-740dfad
```

The application exposes four primary verification endpoints:

```text
/
/health
/version
/api/status
```

The Docker image runs with:

```text
NODE_ENV=production
```

Azure Container Apps startup, readiness, and liveness checks use:

```text
/health
```

This is important because the controlled Phase 10 defect intentionally did not modify `/health`.

---

## 2. Known-Good Production Baseline

Before beginning the failure exercise, the existing production deployment was audited.

Known-good production BUILD_ID:

```text
sha-9c386e0
```

Known-good immutable image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

Known-good Azure revision:

```text
ca-devops-portfolio-api--cd-9c386e0
```

The production revision was verified as:

```text
Active:             True
TrafficWeight:      100
HealthState:        Healthy
ProvisioningState:  Provisioned
```

The following endpoints were verified before introducing the defect:

```text
/             healthy application response
/health       healthy
/version      expected BUILD_ID
/api/status   operational / production
```

The immutable image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

was also verified to still exist in the container registry.

This established a known-good rollback artifact before production risk was introduced.

---

## 3. Azure Rollback Capability Audit

The Azure Container App configuration was inspected before the controlled production failure.

Revision mode:

```text
Single
```

Maximum inactive revisions:

```text
100
```

Health probe endpoint:

```text
/health
```

Container port:

```text
3000
```

Startup, readiness, and liveness behavior all depended on `/health`.

The currently ready production revision was:

```text
ca-devops-portfolio-api--cd-9c386e0
```

The rollback image was confirmed as available:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

The Azure CLI also supported the commands required for emergency recovery, including:

```text
az containerapp update
az containerapp revision list
az containerapp revision show
az containerapp revision activate
az containerapp revision deactivate
```

---

## 4. Failure Scenario Selection

The objective was not to create a simple syntax, unit-test, Docker-build, or infrastructure failure.

Those failure types would be detected before production and would not demonstrate the value of post-deployment validation.

Instead, the Phase 10 exercise deliberately selected a functional production-only defect.

The `/api/status` endpoint normally returns an environment value derived from:

```javascript
environment: process.env.NODE_ENV || 'development',
```

Because the Docker image sets:

```text
NODE_ENV=production
```

the expected production response is:

```json
{
  "status": "operational",
  "environment": "production"
}
```

The controlled defect temporarily changed the behavior so that when:

```text
NODE_ENV=production
```

the endpoint returned:

```json
{
  "status": "operational",
  "environment": "staging"
}
```

The intentional source change was conceptually:

```javascript
environment:
  process.env.NODE_ENV === 'production'
    ? 'staging'
    : (process.env.NODE_ENV || 'development'),
```

The `/health` endpoint was not changed.

No test, security control, health probe, or CI validation mechanism was weakened in order to create the failure.

---

## 5. Why the Defect Passed Normal CI

The automated application tests verify `/api/status`.

However, the test environment does not set:

```text
NODE_ENV=production
```

The normal test expectation therefore remains based on:

```text
development
```

while Docker production execution uses:

```text
production
```

This allowed the controlled production-only defect to demonstrate the following pattern:

```text
Application Quality             PASS
Docker Build                     PASS
Publish Container Image          PASS
Deploy to Azure                  PASS
Azure infrastructure health      PASS
Post-Deployment Smoke Tests      FAIL
```

That failure pattern was the desired Phase 10 scenario.

---

## 6. Local Validation Before Production

The controlled defect was validated locally before being committed.

### ESLint

Result:

```text
PASS
```

### Automated tests

Result:

```text
tests: 5
pass: 5
fail: 0
```

The normal automated test suite therefore did not reject the production-only behavior.

### Docker image build

A controlled-failure image was successfully built locally.

Local image:

```text
devops-ci-cd-portfolio:phase10-controlled-failure
```

### Production-style local runtime

The image was started locally using Docker.

Test BUILD_ID:

```text
sha-phase10-test
```

The container became healthy.

The local health endpoint returned:

```json
{
  "status": "healthy"
}
```

The `/version` endpoint returned:

```text
sha-phase10-test
```

The `/api/status` endpoint returned:

```json
{
  "status": "operational",
  "environment": "staging",
  "buildId": "sha-phase10-test"
}
```

### Real production smoke-test script

The actual Phase 9 post-deployment smoke-test script was executed against the local controlled-failure container.

The following contracts passed:

```text
/
 /health
 /version
```

The `/api/status` contract failed with:

```text
expected environment "production", received "staging"
```

The smoke-test process exited with a non-zero status.

This proved the failure-detection mechanism before the change was allowed to reach Azure.

---

## 7. Controlled Failure Branch

The controlled failure was developed on:

```text
feat/phase-10-failure-rollback
```

Controlled-failure commit:

```text
celba3579e2fb2044cd7eb3179169f83432ce06f
```

Commit message:

```text
test: simulate production status contract failure
```

The commit modified only:

```text
src/app.js
```

with:

```text
1 insertion
1 deletion
```

Before push, the branch was verified to be exactly one commit ahead of the existing `origin/main`.

---

## 8. Controlled Failure Pull Request

The controlled defect was submitted through:

```text
PR #12
```

Title:

```text
test: simulate production status contract failure
```

The pull-request CI workflow produced:

```text
Release Change Detection         success
Application Quality              success
Docker Build                     success
Publish Container Image          skipped
Deploy to Azure                  skipped
Post-Deployment Smoke Tests      skipped
```

This demonstrated the PR security gate.

The defect could be reviewed and validated without publishing a container image or deploying to Azure.

PR #12 was verified as:

```text
OPEN
MERGEABLE
CLEAN
```

before deliberate production merge.

---

## 9. Final Pre-Merge Production Safety Gate

Immediately before merging the controlled failure, the following were verified:

Current known-good BUILD_ID:

```text
sha-9c386e0
```

Current known-good image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

Current `/health` response:

```json
{
  "status": "healthy"
}
```

Current `/api/status` environment:

```text
production
```

Known-good rollback image:

```text
AVAILABLE
```

Rollback values were prepared before the defective merge:

```text
Rollback image:
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0

Rollback BUILD_ID:
sha-9c386e0

Rollback suffix:
rollback-9c386e0
```

---

## 10. Controlled Production Deployment

PR #12 was deliberately squash-merged.

Controlled-failure main commit:

```text
be308107bdaa1705d4d71c8f13e8ee523c18a7b2
```

Short deployment identity:

```text
be30810
```

Defective production BUILD_ID:

```text
sha-be30810
```

Defective immutable image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-be30810
```

Defective Azure revision:

```text
ca-devops-portfolio-api--cd-be30810
```

Production workflow run:

```text
31715492820
```

---

## 11. Production Workflow Failure Pattern

The controlled production workflow produced the exact expected outcome.

Successful jobs:

```text
Release Change Detection
Application Quality
Docker Build
Publish Container Image
Deploy to Azure
```

Failed job:

```text
Post-Deployment Smoke Tests
```

The check-run result was:

```text
Post-Deployment Smoke Tests     completed     failure
Deploy to Azure                 completed     success
Publish Container Image         completed     success
Application Quality             completed     success
Docker Build                     completed     success
Release Change Detection         completed     success
```

This isolated the defect to deployed application correctness rather than infrastructure deployment.

---

## 12. Smoke-Test Failure Diagnosis

The failed job logs were inspected.

### Root endpoint

```text
GET /
HTTP 200
PASS
```

Response contract verified successfully.

### Health endpoint

```text
GET /health
HTTP 200
PASS
```

Response:

```json
{
  "status": "healthy"
}
```

### Version endpoint

```text
GET /version
HTTP 200
PASS
```

Response included:

```text
buildId: sha-be30810
```

### API status endpoint

```text
GET /api/status
HTTP 200
```

Response:

```json
{
  "status": "operational",
  "environment": "staging",
  "version": "0.1.0",
  "buildId": "sha-be30810",
  "nodeVersion": "v24.19.0"
}
```

The production smoke test expected:

```text
environment = production
```

but received:

```text
environment = staging
```

The exact error was:

```text
ERROR: /api/status: expected environment "production", received "staging"
```

The process ended with:

```text
Process completed with exit code 1
```

---

## 13. Why HTTP 200 Was Not Sufficient

The defective endpoint still returned:

```text
HTTP 200
```

Therefore a basic availability-only check would have incorrectly considered the endpoint successful.

The post-deployment smoke test validated application semantics, not merely availability.

This demonstrated the difference between:

```text
Service availability
```

and:

```text
Application correctness
```

A successful HTTP status code did not guarantee a correct business response contract.

---

## 14. Azure Runtime Diagnosis

The Azure deployment was inspected while the defective revision was still live.

BUILD_ID:

```text
sha-be30810
```

Container image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-be30810
```

Azure revision:

```text
ca-devops-portfolio-api--cd-be30810
```

Azure reported:

```text
Active:             True
TrafficWeight:      100
HealthState:        Healthy
ProvisioningState:  Provisioned
```

The `/health` endpoint continued to return:

```json
{
  "status": "healthy"
}
```

while `/api/status` returned:

```json
{
  "status": "operational",
  "environment": "staging",
  "buildId": "sha-be30810"
}
```

This demonstrated:

> Infrastructure health does not guarantee application functional correctness.

---

## 15. Deployment Identity Correlation

The defective runtime could be traced across four layers.

### Git commit

```text
be308107bdaa1705d4d71c8f13e8ee523c18a7b2
```

### Container image

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-be30810
```

### Azure revision

```text
ca-devops-portfolio-api--cd-be30810
```

### Runtime BUILD_ID

```text
sha-be30810
```

This provided the traceability chain:

```text
Git commit
    ↓
Immutable container image
    ↓
Azure revision
    ↓
Runtime BUILD_ID
```

---

## 16. Root Cause

The root cause was the intentionally introduced production-only logic in `src/app.js`.

Correct behavior:

```javascript
environment: process.env.NODE_ENV || 'development',
```

Controlled defect:

```javascript
environment:
  process.env.NODE_ENV === 'production'
    ? 'staging'
    : (process.env.NODE_ENV || 'development'),
```

The Dockerfile sets:

```text
NODE_ENV=production
```

Therefore the controlled defect appeared in Docker and Azure production-style runtimes.

Normal local test execution did not use the same production environment value.

This explains why:

```text
Application Quality
```

passed while:

```text
Post-Deployment Smoke Tests
```

failed.

---

## 17. Emergency Recovery Decision

Once the failure and production identity were captured, restoring production became the immediate priority.

The previously verified immutable recovery artifact was:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

Associated BUILD_ID:

```text
sha-9c386e0
```

The image had already passed production validation before the incident.

Using this artifact avoided rebuilding historical source during an active production incident.

---

## 18. Emergency Rollback

Production was restored using Azure Container Apps with:

```text
Image:
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

Environment:

```text
BUILD_ID=sha-9c386e0
```

Rollback revision suffix:

```text
rollback-9c386e0
```

The resulting Azure revision was:

```text
ca-devops-portfolio-api--rollback-9c386e0
```

The rollback revision became ready immediately.

Azure reported:

```text
Active:             True
Replicas:           1
TrafficWeight:      100
HealthState:        Healthy
ProvisioningState:  Provisioned
```

---

## 19. Emergency Rollback Verification

After rollback, the production application was fully revalidated.

### BUILD_ID

```text
sha-9c386e0
```

### Image

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

### Root endpoint

```text
GET /
HTTP 200
PASS
```

### Health endpoint

```text
GET /health
HTTP 200
PASS
```

### Version endpoint

```text
GET /version
HTTP 200
```

BUILD_ID:

```text
sha-9c386e0
```

### API status endpoint

```text
GET /api/status
HTTP 200
```

Environment:

```text
production
```

### Full production smoke test

The actual production smoke-test script was executed again.

Result:

```text
POST-DEPLOYMENT SMOKE TEST PASSED
```

This confirmed that the emergency rollback restored correct production behavior.

---

## 20. Rollback vs Permanent Remediation

The emergency rollback restored production, but the Git source of truth still contained the controlled defect.

At that point:

```text
Azure production
```

was running:

```text
sha-9c386e0
```

while:

```text
origin/main
```

still contained:

```text
be308107...
```

Therefore a separate source remediation was required.

Operationally:

```text
Emergency rollback
```

restores service quickly.

```text
Permanent source remediation
```

repairs the source of truth and prevents the defect from returning during the next deployment.

Both operations were necessary.

---

## 21. Source Remediation Branch

A dedicated fix branch was created from the defective `origin/main`:

```text
fix/phase-10-production-status-remediation
```

Starting defective commit:

```text
be308107bdaa1705d4d71c8f13e8ee523c18a7b2
```

The controlled defect was removed.

The application was restored to:

```javascript
environment: process.env.NODE_ENV || 'development',
```

Only:

```text
src/app.js
```

was modified.

---

## 22. Local Remediation Validation

The corrected source was validated locally before push.

### ESLint

```text
PASS
```

### Automated tests

```text
tests: 5
pass: 5
fail: 0
```

### Docker build

Corrected local image:

```text
devops-ci-cd-portfolio:phase10-remediated
```

Build result:

```text
PASS
```

### Production-style remediated container

Test BUILD_ID:

```text
sha-phase10-remediated
```

Container health:

```text
healthy
```

The `/api/status` response correctly reported:

```json
{
  "status": "operational",
  "environment": "production",
  "buildId": "sha-phase10-remediated"
}
```

### Full smoke-test validation

The actual post-deployment smoke-test script was executed against the corrected local container.

Result:

```text
POST-DEPLOYMENT SMOKE TEST PASSED
```

---

## 23. Remediation Commit

Source remediation commit:

```text
6d3bd6
```

Commit message:

```text
fix: restore production status contract
```

The commit modified only:

```text
src/app.js
```

with:

```text
1 insertion
1 deletion
```

The branch was verified to be exactly one commit ahead of the defective `origin/main`.

---

## 24. Recovery Pull Request

The source fix was submitted through:

```text
PR #13
```

Title:

```text
fix: restore production status contract
```

PR validation results:

```text
Release Change Detection         success
Application Quality              success
Docker Build                     success
Publish Container Image          skipped
Deploy to Azure                  skipped
Post-Deployment Smoke Tests      skipped
```

The PR contained only:

```text
src/app.js
```

with:

```text
1 addition
1 deletion
```

Before merge, PR #13 was verified as:

```text
OPEN
MERGEABLE
CLEAN
```

---

## 25. Permanent Remediation Merge

PR #13 was squash-merged.

Corrected main commit:

```text
740dfade8c3e9bd8dc64e5bc6012221d983df221
```

Short deployment identity:

```text
740dfad
```

Corrected production BUILD_ID:

```text
sha-740dfad
```

Corrected immutable image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-740dfad
```

Corrected Azure revision:

```text
ca-devops-portfolio-api--cd-740dfad
```

Corrected production workflow run:

```text
31727240007
```

---

## 26. Final Corrected Production Workflow

The corrected source triggered a fresh production deployment.

All six jobs completed successfully:

```text
Release Change Detection        success
Application Quality             success
Docker Build                    success
Publish Container Image         success
Deploy to Azure                 success
Post-Deployment Smoke Tests     success
```

This demonstrated that the permanent source remediation, rather than only the emergency rollback, corrected the system.

---

## 27. Final Production Runtime Verification

Final BUILD_ID:

```text
sha-740dfad
```

Final immutable image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-740dfad
```

Final Azure revision:

```text
ca-devops-portfolio-api--cd-740dfad
```

Azure state:

```text
Active:             True
TrafficWeight:      100
HealthState:        Healthy
ProvisioningState:  Provisioned
```

The final application endpoints returned correct responses:

```text
/             PASS
/health       PASS
/version      PASS
/api/status   PASS
```

Final `/api/status` values included:

```text
status:      operational
environment: production
buildId:     sha-740dfad
```

The final manual smoke-test result was:

```text
POST-DEPLOYMENT SMOKE TEST PASSED
```

---

## 28. Repository Synchronization and Cleanup

After the corrected deployment succeeded:

- local `main` was synchronized with `origin/main`
- the controlled-failure feature branch was removed locally
- the controlled-failure feature branch was removed remotely
- the source-remediation branch was removed locally
- the source-remediation branch was removed remotely
- remote references were pruned
- the repository working tree was verified clean

Final synchronized SHA:

```text
740dfade8c3e9bd8dc64e5bc6012221d983df221
```

Final repository state:

```text
Branch: main
Local main == origin/main
Working tree clean
```

---

## 29. Troubleshooting Sequence Used

The incident was investigated using the following sequence:

```text
1. Detect CI/CD workflow failure
        ↓
2. Identify the failed job
        ↓
3. Inspect failed smoke-test logs
        ↓
4. Identify exact endpoint contract failure
        ↓
5. Verify deployed BUILD_ID
        ↓
6. Verify deployed immutable image
        ↓
7. Inspect Azure revision state
        ↓
8. Query /health directly
        ↓
9. Query /api/status directly
        ↓
10. Correlate runtime identity with source commit
        ↓
11. Determine root cause
        ↓
12. Restore verified known-good image
        ↓
13. Validate emergency recovery
        ↓
14. Create dedicated remediation branch
        ↓
15. Validate source correction locally
        ↓
16. Submit recovery pull request
        ↓
17. Deploy corrected source
        ↓
18. Verify final production state
```

The sequence intentionally moved from symptoms toward increasingly specific evidence instead of assuming the root cause.

---

## 30. Key Troubleshooting Lessons

### Deployment success is not release success

The Azure deployment job completed successfully even though the deployed application was functionally incorrect.

### HTTP 200 does not prove application correctness

The defective `/api/status` endpoint returned HTTP 200.

Its response contract was still wrong.

### Infrastructure health has limited scope

Azure correctly reported the container as healthy because `/health` was functioning.

That health signal did not validate all application behavior.

### Smoke tests validate what infrastructure probes do not

The post-deployment smoke test detected a defect that was not detected by:

- ESLint
- automated unit/API tests
- Docker build
- container publishing
- Azure deployment
- Azure provisioning
- `/health`

### Immutable images enable deterministic recovery

The known-good image:

```text
sha-9c386e0
```

could be redeployed without rebuilding historical source.

### BUILD_ID supports runtime traceability

The BUILD_ID made it possible to identify exactly which source-derived deployment was active.

### Runtime identity should be correlated across layers

The incident correlated:

```text
Git SHA
container image
Azure revision
BUILD_ID
```

### Emergency rollback and permanent remediation are separate

Rollback restored production quickly.

Source remediation repaired the repository.

### Recovery must be verified

Production was not considered recovered until:

- revision health was verified
- traffic weight was verified
- BUILD_ID was verified
- image identity was verified
- application endpoints were verified
- the complete smoke-test script passed

---

## 31. Evidence

Phase 10 evidence is stored in:

```text
screenshots/phase-10-failure-troubleshooting-rollback/
```

### Evidence 01 — Controlled Production Smoke-Test Failure

File:

```text
01-controlled-production-smoke-test-failure.png
```

Demonstrates:

- Release Change Detection passed
- Application Quality passed
- Docker Build passed
- Publish Container Image passed
- Deploy to Azure passed
- Post-Deployment Smoke Tests failed

---

### Evidence 02 — Smoke-Test Failure Details

File:

```text
02-smoke-test-failure-details.png
```

Demonstrates:

- `/` passed
- `/health` passed
- `/version` passed
- `/api/status` returned HTTP 200
- `/api/status` reported `staging`
- expected environment was `production`
- smoke-test process exited with failure

---

### Evidence 03 — Defective Production Identity

File:

```text
03-defective-production-identity.png
```

Demonstrates:

- BUILD_ID `sha-be30810`
- image `sha-be30810`
- defective Azure revision active
- 100% traffic
- `Healthy`
- `Provisioned`
- `/health` healthy
- `/api/status` functionally incorrect

---

### Evidence 04 — Emergency Rollback Success

File:

```text
04-emergency-rollback-success.png
```

Demonstrates:

- known-good image `sha-9c386e0` restored
- rollback revision active
- 100% traffic
- Azure healthy
- Azure provisioned
- correct production endpoints
- complete production smoke test passed

---

### Evidence 05 — Source Remediation Production Success

File:

```text
05-source-remediation-production-success.png
```

Demonstrates:

- all six production CI/CD jobs succeeded
- corrected BUILD_ID `sha-740dfad`
- corrected immutable image
- corrected Azure revision
- 100% production traffic
- Azure healthy
- Azure provisioned
- `/api/status` restored to `production`
- final smoke test passed

---

### Evidence 06 — Final Main Repository State

File:

```text
06-final-main-repository-state.png
```

Demonstrates:

- branch `main`
- local main SHA matches `origin/main`
- corrected remediation commit is current
- obsolete Phase 10 branches removed
- working tree clean

---

## 32. Useful Troubleshooting Commands

### Current repository state

```bash
git branch --show-current
git status
git log -1 --oneline
```

### Compare local and remote main

```bash
git fetch origin
git rev-parse HEAD
git rev-parse origin/main
```

### Recent main workflows

```bash
gh run list \
  --branch main \
  --limit 10
```

### View failed workflow logs

```bash
gh run view <RUN_ID> --log-failed
```

### Inspect check runs for a commit

```bash
gh api \
  "repos/daryal89/devops-ci-cd-deployment-portfolio/commits/<COMMIT_SHA>/check-runs" \
  --jq '.check_runs[] | [.name,.status,.conclusion] | @tsv'
```

### Current Azure BUILD_ID

```bash
az containerapp show \
  --name "ca-devops-portfolio-api" \
  --resource-group "rg-devops-portfolio-prod" \
  --query "properties.template.containers[0].env[?name=='BUILD_ID'].value | [0]" \
  --output tsv
```

### Current Azure image

```bash
az containerapp show \
  --name "ca-devops-portfolio-api" \
  --resource-group "rg-devops-portfolio-prod" \
  --query "properties.template.containers[0].image" \
  --output tsv
```

### Revision inventory

```bash
az containerapp revision list \
  --name "ca-devops-portfolio-api" \
  --resource-group "rg-devops-portfolio-prod" \
  --output table
```

### Resolve production URL

```bash
FQDN="$(az containerapp show \
  --name "ca-devops-portfolio-api" \
  --resource-group "rg-devops-portfolio-prod" \
  --query "properties.configuration.ingress.fqdn" \
  --output tsv)"

BASE_URL="https://${FQDN}"
```

### Verify health

```bash
curl -fsS "${BASE_URL}/health"
```

### Verify API status

```bash
curl -fsS "${BASE_URL}/api/status"
```

### Run the production smoke test

```bash
bash scripts/post-deployment-smoke-test.sh \
  "$BASE_URL" \
  "<EXPECTED_BUILD_ID>"
```

---

## 33. General Troubleshooting Principles

When investigating a production CI/CD failure:

1. Identify the exact failing pipeline stage.
2. Do not assume infrastructure is the root cause.
3. Separate build failures from deployment failures.
4. Separate infrastructure health from application correctness.
5. Inspect the failed job logs before making changes.
6. Verify the deployed BUILD_ID.
7. Verify the deployed immutable image.
8. Verify the Azure revision.
9. Query the affected application endpoints directly.
10. Correlate runtime identity with the Git commit.
11. Use a previously verified immutable artifact when rapid rollback is required.
12. Restore production before spending unnecessary time on permanent source remediation.
13. Repair source through the normal pull-request process.
14. Redeploy corrected source.
15. Perform complete post-recovery validation.
16. Document the incident and recovery procedure.

---

## 34. Phase 10 Outcome

Phase 10 successfully demonstrated the complete production incident lifecycle:

```text
Controlled production-only defect
        ↓
Local validation
        ↓
PR CI validation
        ↓
Controlled merge to main
        ↓
Immutable image publishing
        ↓
Successful Azure deployment
        ↓
Healthy Azure revision
        ↓
Functional smoke-test failure
        ↓
Structured troubleshooting
        ↓
Runtime identity verification
        ↓
Root-cause identification
        ↓
Emergency immutable-image rollback
        ↓
Production recovery
        ↓
Dedicated source remediation
        ↓
Recovery pull request
        ↓
Corrected production deployment
        ↓
Successful post-deployment smoke tests
        ↓
Branch cleanup
        ↓
Clean synchronized main
```

The exercise provides practical evidence that the portfolio demonstrates more than successful deployment.

It also demonstrates the ability to:

- detect a production application defect
- distinguish infrastructure health from application correctness
- troubleshoot a failed release systematically
- correlate source, image, revision, and runtime identity
- recover using an immutable known-good artifact
- repair the source of truth
- redeploy corrected software through CI/CD
- verify production recovery end-to-end
- preserve evidence of the incident and recovery process
