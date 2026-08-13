# Production Rollback Guide

## DevOps CI/CD Deployment Portfolio — Phase 10

## Purpose

This document defines the emergency rollback procedure demonstrated during Phase 10 of the DevOps CI/CD Deployment Portfolio.

The rollback process is designed for situations where:

- a new production deployment completes,
- Azure reports the revision as healthy and provisioned,
- application-level validation fails,
- a previously verified immutable container image is available,
- production must be restored quickly before permanent source remediation.

The Phase 10 incident demonstrated that deployment success and infrastructure health do not guarantee application correctness.

The rollback procedure therefore prioritizes:

1. rapid production recovery,
2. deterministic artifact selection,
3. runtime identity verification,
4. post-rollback endpoint validation,
5. complete smoke-test verification,
6. permanent source remediation after service recovery.

---

## 1. Rollback Principles

### Use immutable artifacts

Rollback must target a previously verified immutable image.

Phase 10 known-good image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

Associated runtime identity:

```text
BUILD_ID=sha-9c386e0
```

### Do not rebuild historical source during an incident

A rollback should not depend on:

- checking out an old commit,
- rebuilding an old Docker image,
- reproducing historical dependencies,
- recreating an old deployment manually from source.

The immutable image already represents the exact previously verified artifact.

### Recover production before extended remediation

During an active incident:

```text
Restore service
      ↓
Verify recovery
      ↓
Then repair source
```

Permanent source remediation is still required afterward.

### Verify the recovery

A rollback is not complete merely because the Azure CLI command succeeds.

The following must also be verified:

- expected BUILD_ID,
- expected container image,
- active Azure revision,
- 100% production traffic,
- healthy revision state,
- provisioned revision state,
- root endpoint,
- health endpoint,
- version endpoint,
- API status endpoint,
- full post-deployment smoke-test script.

---

## 2. Phase 10 Rollback Scenario

The controlled defective production deployment used:

```text
Git main commit:
be308107bdaa1705d4d71c8f13e8ee523c18a7b2

BUILD_ID:
sha-be30810

Container image:
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-be30810

Azure revision:
ca-devops-portfolio-api--cd-be30810
```

The deployment itself succeeded.

Azure reported:

```text
Active:             True
TrafficWeight:      100
HealthState:        Healthy
ProvisioningState:  Provisioned
```

The `/health` endpoint also returned:

```json
{
  "status": "healthy"
}
```

However, `/api/status` returned:

```json
{
  "status": "operational",
  "environment": "staging",
  "buildId": "sha-be30810"
}
```

The required production contract was:

```text
environment = production
```

The post-deployment smoke test correctly failed.

---

## 3. Known-Good Rollback Target

Before the controlled failure was merged, the rollback artifact was verified.

Image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

BUILD_ID:

```text
sha-9c386e0
```

Original known-good revision:

```text
ca-devops-portfolio-api--cd-9c386e0
```

The image was confirmed to still exist in GitHub Container Registry before production risk was introduced.

This is an important rollback prerequisite.

---

## 4. Pre-Rollback Checklist

Before executing a rollback, verify:

```text
[ ] Incident has been identified
[ ] Failed production behavior has been confirmed
[ ] Current defective BUILD_ID has been recorded
[ ] Current defective image has been recorded
[ ] Current defective revision has been recorded
[ ] Failure evidence has been captured
[ ] Known-good image has been verified as available
[ ] Known-good BUILD_ID is known
[ ] Rollback command values have been prepared
```

For Phase 10:

```text
Defective BUILD_ID:
sha-be30810

Known-good BUILD_ID:
sha-9c386e0

Known-good image:
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0

Rollback suffix:
rollback-9c386e0
```

---

## 5. Verify Known-Good Image Availability

Before changing Azure production, verify the rollback image exists.

```bash
docker manifest inspect   "ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0"   >/dev/null   && echo "PASS: rollback image sha-9c386e0 is available"   || {
    echo "FAIL: rollback image could not be verified"
    exit 1
  }
```

Expected result:

```text
PASS: rollback image sha-9c386e0 is available
```

Do not proceed with a planned rollback target that cannot be verified.

---

## 6. Capture Current Defective Production Identity

Before rollback, record the currently deployed runtime.

### Current BUILD_ID

```bash
az containerapp show   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --query "properties.template.containers[0].env[?name=='BUILD_ID'].value | [0]"   --output tsv
```

### Current image

```bash
az containerapp show   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --query "properties.template.containers[0].image"   --output tsv
```

### Current revision inventory

```bash
az containerapp revision list   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --output table
```

### Current health endpoint

```bash
FQDN="$(az containerapp show   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --query "properties.configuration.ingress.fqdn"   --output tsv)"

curl -fsS "https://${FQDN}/health"
```

### Current API status

```bash
curl -fsS "https://${FQDN}/api/status"
```

---

## 7. Emergency Rollback Command

The Phase 10 emergency rollback used:

```bash
az containerapp update   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --image "ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0"   --revision-suffix "rollback-9c386e0"   --set-env-vars "BUILD_ID=sha-9c386e0"   --output none
```

This command restores:

```text
Image:
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0

BUILD_ID:
sha-9c386e0

Revision suffix:
rollback-9c386e0
```

The rollback command changes the deployed application artifact without changing the Git repository.

---

## 8. Important Safety Notes

### Do not change unrelated environment variables

The rollback should be narrowly scoped.

For Phase 10, the command intentionally changed only:

- container image,
- BUILD_ID,
- revision suffix.

### Do not change health probes during rollback

The existing startup, readiness, and liveness checks should remain unchanged unless the incident itself is caused by invalid probe configuration.

### Do not weaken smoke tests

A failed smoke test is evidence of application behavior.

Do not modify the test simply to make the deployment green.

### Do not delete the defective evidence too early

Capture the defective runtime identity before rollback if it is safe to do so.

For Phase 10, evidence was captured before recovery.

---

## 9. Wait for Rollback Revision Readiness

After executing the rollback, verify the expected revision becomes ready.

```bash
APP="ca-devops-portfolio-api"
RG="rg-devops-portfolio-prod"
EXPECTED_BUILD_ID="sha-9c386e0"

READY=false

for ATTEMPT in {1..18}; do
  REVISION_NAME="$(az containerapp show     --name "$APP"     --resource-group "$RG"     --query "properties.latestReadyRevisionName"     --output tsv)"

  BUILD_ID="$(az containerapp show     --name "$APP"     --resource-group "$RG"     --query "properties.template.containers[0].env[?name=='BUILD_ID'].value | [0]"     --output tsv)"

  echo "Attempt $ATTEMPT/18"
  echo "Ready revision: $REVISION_NAME"
  echo "BUILD_ID:       $BUILD_ID"

  if [[ "$REVISION_NAME" == *"rollback-9c386e0"* && "$BUILD_ID" == "$EXPECTED_BUILD_ID" ]]; then
    READY=true
    break
  fi

  sleep 5
done

if [[ "$READY" != "true" ]]; then
  echo "ERROR: rollback revision did not become ready in the expected time."
  exit 1
fi
```

Phase 10 rollback became ready immediately.

---

## 10. Verify Rollback BUILD_ID

```bash
az containerapp show   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --query "properties.template.containers[0].env[?name=='BUILD_ID'].value | [0]"   --output tsv
```

Expected:

```text
sha-9c386e0
```

---

## 11. Verify Rollback Image

```bash
az containerapp show   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --query "properties.template.containers[0].image"   --output tsv
```

Expected:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0
```

---

## 12. Verify Rollback Revision

```bash
az containerapp revision list   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --output table
```

Expected active rollback revision:

```text
ca-devops-portfolio-api--rollback-9c386e0
```

Expected state:

```text
Active:             True
TrafficWeight:      100
HealthState:        Healthy
ProvisioningState:  Provisioned
```

During Phase 10, the rollback revision also showed one active replica during verification.

---

## 13. Resolve Production URL

```bash
FQDN="$(az containerapp show   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --query "properties.configuration.ingress.fqdn"   --output tsv)"

BASE_URL="https://${FQDN}"

echo "$BASE_URL"
```

Phase 10 production URL:

```text
https://ca-devops-portfolio-api.politedune-2cb686dc.eastus2.azurecontainerapps.io
```

---

## 14. Verify Root Endpoint

```bash
curl -fsS "$BASE_URL/"
```

Expected Phase 10 response:

```json
{
  "message": "DevOps CI/CD Deployment Portfolio API",
  "status": "running"
}
```

---

## 15. Verify Health Endpoint

```bash
curl -fsS "$BASE_URL/health"
```

Expected:

```json
{
  "status": "healthy"
}
```

---

## 16. Verify Version Endpoint

```bash
curl -fsS "$BASE_URL/version"
```

Expected rollback identity:

```json
{
  "version": "0.1.0",
  "buildId": "sha-9c386e0"
}
```

This is important because `/version` confirms that the runtime is actually serving the intended rollback artifact.

---

## 17. Verify API Status Endpoint

```bash
curl -fsS "$BASE_URL/api/status"
```

Expected:

```json
{
  "status": "operational",
  "environment": "production",
  "version": "0.1.0",
  "buildId": "sha-9c386e0"
}
```

The critical recovery signal is:

```text
environment = production
```

The Phase 10 defective deployment had returned:

```text
environment = staging
```

---

## 18. Run Full Post-Deployment Smoke Test

After the endpoint checks succeed, run the real smoke-test script.

```bash
bash scripts/post-deployment-smoke-test.sh   "$BASE_URL"   "sha-9c386e0"
```

Required result:

```text
POST-DEPLOYMENT SMOKE TEST PASSED
```

A rollback should not be declared complete until this validation succeeds.

---

## 19. Phase 10 Rollback Verification Result

The Phase 10 rollback produced:

```text
BUILD_ID:
sha-9c386e0

Image:
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0

Revision:
ca-devops-portfolio-api--rollback-9c386e0

Active:
True

TrafficWeight:
100

HealthState:
Healthy

ProvisioningState:
Provisioned
```

Application result:

```text
/             PASS
/health       PASS
/version      PASS
/api/status   PASS
```

Smoke-test result:

```text
POST-DEPLOYMENT SMOKE TEST PASSED
```

Production recovery was therefore verified.

---

## 20. Evidence of Rollback

Primary Phase 10 rollback evidence:

```text
screenshots/phase-10-failure-troubleshooting-rollback/04-emergency-rollback-success.png
```

This screenshot demonstrates:

- rollback revision name,
- known-good BUILD_ID,
- known-good immutable image,
- 100% production traffic,
- Azure healthy state,
- Azure provisioned state,
- successful application endpoint checks,
- successful production smoke test.

---

## 21. Rollback Is Not Source Remediation

The rollback changed production runtime state only.

After emergency recovery:

```text
Azure production:
sha-9c386e0
```

but Git `origin/main` still contained the controlled defect:

```text
be308107bdaa1705d4d71c8f13e8ee523c18a7b2
```

This is an intentional operational distinction.

Rollback:

```text
restores service
```

Source remediation:

```text
repairs the source of truth
```

After production was safe, Phase 10 created:

```text
fix/phase-10-production-status-remediation
```

and restored:

```javascript
environment: process.env.NODE_ENV || 'development',
```

---

## 22. Permanent Remediation Verification

The corrected source was eventually merged through PR #13.

Corrected main commit:

```text
740dfade8c3e9bd8dc64e5bc6012221d983df221
```

Corrected production image:

```text
ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-740dfad
```

Corrected BUILD_ID:

```text
sha-740dfad
```

Corrected revision:

```text
ca-devops-portfolio-api--cd-740dfad
```

The final production workflow completed all six jobs successfully.

This permanently realigned:

```text
Git source
container image
Azure revision
runtime BUILD_ID
```

---

## 23. Emergency Rollback Decision Tree

Use the following decision process during a production incident:

```text
Production validation fails
        ↓
Is the failure reproducible?
        ↓
YES
        ↓
Can the current runtime identity be verified?
        ↓
YES
        ↓
Is a previously verified immutable image available?
        ↓
YES
        ↓
Capture required incident evidence
        ↓
Redeploy known-good immutable image
        ↓
Verify BUILD_ID + image + revision
        ↓
Verify endpoints
        ↓
Run full smoke test
        ↓
Production recovered
        ↓
Repair source through normal PR workflow
```

If no known-good artifact can be verified, do not guess a rollback target.

---

## 24. Rollback Validation Checklist

After rollback, confirm all items:

```text
[ ] expected rollback revision is ready
[ ] expected BUILD_ID is deployed
[ ] expected immutable image is deployed
[ ] revision is Active
[ ] TrafficWeight is 100
[ ] HealthState is Healthy
[ ] ProvisioningState is Provisioned
[ ] root endpoint passes
[ ] health endpoint passes
[ ] version endpoint reports rollback BUILD_ID
[ ] API status reports production
[ ] complete smoke-test script passes
```

Only after every required item is verified should the rollback be considered complete.

---

## 25. Common Rollback Mistakes to Avoid

### Rolling back without verifying the artifact

Do not assume an image still exists.

Verify it first.

### Using mutable tags

Avoid relying on tags such as:

```text
latest
production
stable
```

for emergency recovery.

Prefer immutable SHA-derived tags.

### Updating production before recording the defective identity

When practical and safe, capture:

- current BUILD_ID,
- current image,
- current revision,
- current failing application response.

This preserves troubleshooting evidence.

### Declaring success after the CLI command

The command completing does not prove recovery.

Verify the runtime.

### Skipping smoke tests after rollback

The same validation layer that detected the incident should confirm the recovery.

### Leaving defective source on main indefinitely

Emergency rollback does not fix source control.

Create permanent remediation promptly after service recovery.

### Making unrelated production changes during rollback

Keep the emergency change narrowly scoped.

---

## 26. Useful Rollback Commands

### Verify known-good image

```bash
docker manifest inspect   "ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0"
```

### Current BUILD_ID

```bash
az containerapp show   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --query "properties.template.containers[0].env[?name=='BUILD_ID'].value | [0]"   --output tsv
```

### Current image

```bash
az containerapp show   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --query "properties.template.containers[0].image"   --output tsv
```

### Revision inventory

```bash
az containerapp revision list   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --output table
```

### Emergency rollback

```bash
az containerapp update   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --image "ghcr.io/daryal89/devops-ci-cd-deployment-portfolio:sha-9c386e0"   --revision-suffix "rollback-9c386e0"   --set-env-vars "BUILD_ID=sha-9c386e0"   --output none
```

### Resolve public URL

```bash
FQDN="$(az containerapp show   --name "ca-devops-portfolio-api"   --resource-group "rg-devops-portfolio-prod"   --query "properties.configuration.ingress.fqdn"   --output tsv)"

BASE_URL="https://${FQDN}"
```

### Smoke-test rollback

```bash
bash scripts/post-deployment-smoke-test.sh   "$BASE_URL"   "sha-9c386e0"
```

---

## 27. Interview-Level Explanation

A concise explanation of the Phase 10 rollback process:

> The deployment itself succeeded and Azure reported the revision as healthy, but the post-deployment smoke test detected that `/api/status` returned the wrong production environment value. I verified the bad BUILD_ID, image, and active Azure revision, then restored the previously verified immutable `sha-9c386e0` image with the matching BUILD_ID. I validated the new rollback revision, 100% traffic, Azure health, all four application endpoints, and reran the complete smoke-test suite. Once production was stable, I repaired the defect separately through a remediation branch and pull request, then deployed a fresh corrected immutable image.

This demonstrates both rapid operational recovery and disciplined source remediation.

---

## 28. Rollback Outcome

The Phase 10 rollback demonstrated the complete emergency recovery path:

```text
Functional production defect
        ↓
Smoke test detects failure
        ↓
Runtime identity verified
        ↓
Known-good immutable image selected
        ↓
Emergency Azure update
        ↓
Rollback revision becomes ready
        ↓
100% traffic restored
        ↓
Application endpoints validated
        ↓
Smoke tests pass
        ↓
Production recovered
        ↓
Permanent source remediation follows
```

The exercise demonstrates practical rollback capability using Azure Container Apps, immutable container artifacts, runtime BUILD_ID traceability, application contract validation, and post-recovery verification.
