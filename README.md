# MANIFEST-CD-DEMO

A demonstration repository showcasing an minimalistic approach to continuous deployment (CD) of Kubernetes manifests in a multi-tenant environment. This project automates the generation of deployment pipelines and configurations for isolated tenants, optimizing deployments based on configuration changes.

## Features

- **Multi-Tenant Manifest Management**: Supports base manifests with tenant-specific overrides for customized deployments.
- **Dynamic Pipeline Generation**: Automatically generates CI/CD jobs for tenants based on manifest changes.
- **Change Detection**: On merges to `main`, detects config changes in `tenant-specific-overrides/` and deploys only affected tenants.
- **Local and CI Execution**: Run deployments locally or via GitHub Actions.
- **Kubernetes-Ready**: Designed for K8s manifests, with extensible scripts for real deployments.

## Project Structure

```
.
├── .github/workflows/ci.yml          # GitHub Actions workflow for CI/CD
├── .gitlab-ci.yml                    # Alternative GitLab CI configuration
├── manifests/                        # Base manifests and tenant-specific files
│   ├── default-manifest.yaml         # Shared base configuration
│   ├── tenant1.yaml                  # Tenant1 manifest
│   └── tenant2.yaml                  # Tenant2 manifest
├── tenant-specific-overrides/        # Per-tenant customizations
│   ├── tenant1/
│   │   └── tenant1-config.yaml       # Overrides for tenant1
│   └── tenant2/
│       └── tenant2-config.yaml       # Overrides for tenant2
├── deploy                            # Script to generate deployment configs
├── generate-tenant-jobs              # Script to create tenant pipelines
├── run-pipeline-jobs.sh             # Local runner for pipeline jobs
├── tenant-deployment-pipeline.yml    # Generated pipeline (GitLab CI format)
└── README.md                         # This file
```

## Prerequisites

- **Git**: For version control and change detection.
- **Bash**: Scripts are written in Bash (macOS/Linux compatible).
- **GitHub Actions** or **GitLab CI**: For automated CI/CD (optional for local use).
- **Optional**: `yq` for advanced YAML parsing (install via `brew install yq` on macOS).

## Installation and Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/AI-manifest-cd-demo.git
   cd AI-manifest-cd-demo
   ```

2. **Make Scripts Executable**:
   ```bash
   chmod +x generate-tenant-jobs deploy run-pipeline-jobs.sh
   ```

3. **Configure Tenants**:
   - Edit `manifests/default-manifest.yaml` for base settings.
   - Add/update tenant configs in `tenant-specific-overrides/tenantX/tenantX-config.yaml`.
   - Add new tenant manifests in `manifests/tenantX.yaml` and corresponding overrides.

## Usage

### Local Execution

1. **Generate Pipeline**:
   ```bash
   ./generate-tenant-jobs
   ```
   - Creates `tenant-deployment-pipeline.yml` with jobs for all tenants.
   - On `main` branch, detects changes and generates only for affected tenants.

2. **Run Deployments**:
   ```bash
   ./deploy
   ```
   - Deploys for all tenants in the pipeline, using their variables.

3. **Run Pipeline Jobs Locally**:
   ```bash
   ./run-pipeline-jobs.sh
   ```
   - Executes deployments sequentially for each tenant.

### CI/CD Execution

- **GitHub Actions**: Pushes to `main`/`qa` trigger the workflow in `.github/workflows/ci.yml`.
  - Generates pipelines and deploys based on changes.
  - Merges to `main` detect config changes and deploy selectively.

- **GitLab CI**: Use `.gitlab-ci.yml` for automatic job inclusion from `tenant-deployment-pipeline.yml`.

### Example Workflow

1. Update `tenant-specific-overrides/tenant1/tenant1-config.yaml`.
2. Push to `qa` branch.
3. Create PR to `main`.
4. Merge: CI detects changes, generates pipeline for `tenant1`, deploys it.

## How It Works

1. **Manifest Management**:
   - `manifests/` holds base and tenant manifests.
   - `tenant-specific-overrides/` provides per-tenant variables (e.g., environment, settings).

2. **Pipeline Generation** (`generate-tenant-jobs`):
   - Iterates over `manifests/*.yaml` to identify tenants.
   - Extracts variables from overrides.
   - Outputs `tenant-deployment-pipeline.yml` with jobs (GitLab CI format).

3. **Deployment** (`deploy`):
   - Parses the pipeline for tenants and variables.
   - Generates configs in `deployment-configs/` (e.g., JSON summaries, text files).

4. **Change Detection**:
   - On `main`, uses `git diff-tree` to find changed configs.
   - Deploys only affected tenants to optimize CI.

5. **CI Integration**:
   - GitHub Actions runs scripts on relevant changes.
   - Supports merge commit detection for incremental deployments.

## Contributing

1. Fork the repo.
2. Create a feature branch.
3. Make changes, test locally.
4. Submit a PR with a clear description.

## License

MIT License. See LICENSE file for details.

## Notes

- This is a demo; extend scripts for real K8s deployments (e.g., integrate `kubectl`).
- For production, add security, testing, and rollback logic.
- Inspired by multi-tenant K8s patterns; "AI" refers to intelligent automation.