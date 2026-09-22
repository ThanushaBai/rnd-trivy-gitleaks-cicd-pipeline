# R&D: Trivy & Gitleaks on CI/CD Pipeline

Research and integration of **Trivy** (container vulnerability scanning) and
**Gitleaks** (secret detection) into a **Jenkins** CI/CD pipeline, with
**Harbor** registry security gates for Nomad deployments.

## Architecture

GitHub → Jenkins (Docker) → Gitleaks Scan → Docker Build → Trivy Scan → Harbor → Nomad

## Pipeline Stages

| Stage | Tool | Gate Behavior |
|---|---|---|
| Checkout | Git | — |
| **Gitleaks Secret Scan** | Gitleaks v8 | ❌ Blocks build on any secret detected |
| Docker Build | Docker | — |
| Trivy Image Scan (coming) | Trivy | ❌ Blocks on CRITICAL/HIGH CVEs |
| Push to Harbor (coming) | Harbor | Registry-level Trivy scan + "Prevent vulnerable images" policy |

## Gitleaks — Proof of Concept

Verified Gitleaks detects hardcoded secrets and **blocks the pipeline before
any Docker image is built**:

- Planted a fake high-entropy GitHub token (`ghp_...`) in `test-secret.env`
- Pushed to repo → Jenkins build **FAILED** at the Gitleaks stage
- Stages `Build Docker Image` and `Verify Image` were **skipped**
- Console output:
Finding: GITHUB_TOKEN=REDACTED
RuleID: github-pat
Entropy: 4.671928
leaks found: 1
ERROR: script returned exit code 1
Finished: FAILURE

## Coming Next

- Trivy image scanning stage
- Harbor registry integration with auto-scan on push
- Security gate documentation + recommendations
