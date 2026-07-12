# Container Apps Deployment

Marmalade deploys to Azure Container Apps with two images:

- `marmalade-frontend`: public React static site served by nginx.
- `marmalade-backend`: private/internal Express API.

The frontend is the only public Container App. Its nginx config proxies `/api/*` to the internal backend Container App, so browser requests remain same-origin.

## Local Container Verification

The normal local development flow remains npm-based:

```sh
npm run dev --prefix backend
npm run dev --prefix frontend
```

Use Docker Compose only when you want to verify the production-style container wiring:

```sh
docker compose up --build
```

Compose expects these values in your shell or a root `.env` file. Use `.env.example` as the checklist:

```sh
MONGO_URI=
JWT_SECRET_KEY=
STREAM_API_KEY=
STREAM_API_SECRET=
VITE_STREAM_API_KEY=
```

Open `http://localhost:8080`. The frontend container proxies `/api` to the backend container at `http://backend:5001`.

## Azure Architecture

- Azure Container Registry stores the frontend and backend images.
- Azure Container Apps Environment hosts both apps.
- Frontend ingress is external on port `80`.
- Backend ingress is internal on port `5001`.
- Both apps use single-revision mode.
- Backend secrets are stored as Container App secrets and exposed as environment variables.
- The frontend image bakes in `VITE_STREAM_API_KEY` at build time.
- Runtime API routing uses nginx `BACKEND_URL`, not a Vite API URL.

## GitHub Actions

The workflow is `.github/workflows/azure-container-apps.yml`.

It has two jobs:

- `ci`: installs dependencies, lints the frontend, and builds the frontend.
- `cd`: logs into Azure, provisions ACR, builds and pushes both images, then deploys Container Apps with Bicep.

Required GitHub environment or repository secrets:

```sh
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
MONGO_URI
JWT_SECRET_KEY
STREAM_API_KEY
STREAM_API_SECRET
VITE_STREAM_API_KEY
```

The Azure identity used by GitHub Actions needs permission to create resources in the target resource group and assign `AcrPull` roles to the managed identities created for the Container Apps.

## Bicep Files

- `infra/registry.bicep`: creates Azure Container Registry first so images can be pushed.
- `infra/main.bicep`: creates Log Analytics, Container Apps Environment, managed identities, role assignments, and the frontend/backend Container Apps.

The two-step provisioning is intentional: Container Apps need real image references, and the images cannot exist until ACR exists.

## Health Check

The backend exposes:

```txt
GET /api/health
```

ACA uses this path for liveness and readiness probes.
