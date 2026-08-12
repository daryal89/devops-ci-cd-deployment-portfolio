#!/usr/bin/env bash

set -euo pipefail

BASE_URL="${1:-${BASE_URL:-}}"
EXPECTED_BUILD_ID="${2:-${EXPECTED_BUILD_ID:-}}"

if [[ -z "$BASE_URL" ]]; then
  echo "ERROR: BASE_URL is required."
  echo "Usage: bash scripts/post-deployment-smoke-test.sh <base-url> <expected-build-id>"
  exit 1
fi

if [[ -z "$EXPECTED_BUILD_ID" ]]; then
  echo "ERROR: EXPECTED_BUILD_ID is required."
  echo "Usage: bash scripts/post-deployment-smoke-test.sh <base-url> <expected-build-id>"
  exit 1
fi

BASE_URL="${BASE_URL%/}"

command -v curl >/dev/null 2>&1 || {
  echo "ERROR: curl is required."
  exit 1
}

command -v node >/dev/null 2>&1 || {
  echo "ERROR: node is required."
  exit 1
}

fetch_endpoint() {
  local path="$1"
  local attempt
  local http_code
  local body_file

  body_file="$(mktemp)"

  for attempt in {1..18}; do
    http_code="$(
      curl \
        --silent \
        --show-error \
        --connect-timeout 10 \
        --max-time 20 \
        --output "$body_file" \
        --write-out "%{http_code}" \
        "$BASE_URL$path" || true
    )"

    if [[ "$http_code" == "200" ]]; then
      cat "$body_file"
      rm -f "$body_file"
      return 0
    fi

    echo \
      "Attempt ${attempt}/18: ${path} returned HTTP ${http_code:-curl-error}; retrying..." \
      >&2

    if [[ "$attempt" -lt 18 ]]; then
      sleep 5
    fi
  done

  echo "ERROR: ${path} did not return HTTP 200." >&2
  echo "Last response:" >&2
  cat "$body_file" >&2 || true
  rm -f "$body_file"

  return 1
}

validate_response() {
  local endpoint="$1"
  local body="$2"
  local endpoint_key

  case "$endpoint" in
    "/")
      endpoint_key="root"
      ;;
    "/health")
      endpoint_key="health"
      ;;
    "/version")
      endpoint_key="version"
      ;;
    "/api/status")
      endpoint_key="api-status"
      ;;
    *)
      echo "ERROR: unsupported endpoint ${endpoint}" >&2
      return 1
      ;;
  esac

  ENDPOINT_KEY="$endpoint_key" \
  JSON_BODY="$body" \
  EXPECTED_BUILD_ID="$EXPECTED_BUILD_ID" \
  node <<'NODE'
const endpointKey = process.env.ENDPOINT_KEY;
const expectedBuildId = process.env.EXPECTED_BUILD_ID;

const endpointNames = {
  root: "/",
  health: "/health",
  version: "/version",
  "api-status": "/api/status"
};

const endpoint = endpointNames[endpointKey];

if (!endpoint) {
  console.error(`ERROR: unsupported endpoint key ${endpointKey}`);
  process.exit(1);
}

let data;

try {
  data = JSON.parse(process.env.JSON_BODY);
} catch (error) {
  console.error(`ERROR: ${endpoint} returned invalid JSON.`);
  process.exit(1);
}

function requireValue(condition, message) {
  if (!condition) {
    console.error(`ERROR: ${endpoint}: ${message}`);
    console.error(`Response: ${JSON.stringify(data)}`);
    process.exit(1);
  }
}

switch (endpointKey) {
  case "root":
    requireValue(
      data.status === "running",
      `expected status "running", received ${JSON.stringify(data.status)}`
    );
    break;

  case "health":
    requireValue(
      data.status === "healthy",
      `expected status "healthy", received ${JSON.stringify(data.status)}`
    );
    break;

  case "version":
    requireValue(
      typeof data.version === "string" && data.version.length > 0,
      "expected a non-empty version"
    );
    requireValue(
      data.buildId === expectedBuildId,
      `expected buildId "${expectedBuildId}", received ${JSON.stringify(data.buildId)}`
    );
    break;

  case "api-status":
    requireValue(
      data.status === "operational",
      `expected status "operational", received ${JSON.stringify(data.status)}`
    );
    requireValue(
      data.environment === "production",
      `expected environment "production", received ${JSON.stringify(data.environment)}`
    );
    requireValue(
      data.buildId === expectedBuildId,
      `expected buildId "${expectedBuildId}", received ${JSON.stringify(data.buildId)}`
    );
    break;

  default:
    console.error(`ERROR: unsupported endpoint key ${endpointKey}`);
    process.exit(1);
}

console.log(`PASS: ${endpoint} response contract verified`);
NODE
}

echo "============================================================"
echo " POST-DEPLOYMENT PRODUCTION SMOKE TEST"
echo "============================================================"
echo "Base URL:          $BASE_URL"
echo "Expected BUILD_ID: $EXPECTED_BUILD_ID"

for endpoint in "/" "/health" "/version" "/api/status"; do
  echo
  echo "=== Testing ${endpoint} ==="

  response="$(fetch_endpoint "$endpoint")"

  echo "HTTP 200"
  echo "Response: $response"

  validate_response "$endpoint" "$response"
done

echo
echo "============================================================"
echo " POST-DEPLOYMENT SMOKE TEST PASSED"
echo "============================================================"
