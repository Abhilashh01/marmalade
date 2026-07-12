# DevOps and Cloud Notes

Marmalade targets Azure Container Apps for production v1.

## Deployment Model

- Frontend: public Container App serving a Vite build through nginx.
- Backend: internal Container App running the Express API.
- API routing: nginx proxies frontend `/api/*` requests to the internal backend.
- Revision mode: single revision for both apps.
- Environment: one production environment for v1.

This replaces the previous single-artifact App Service deployment path.

## Infrastructure

Infrastructure is defined in Bicep:

- `infra/registry.bicep` creates Azure Container Registry.
- `infra/main.bicep` creates Log Analytics, Container Apps Environment, managed identities, ACR pull role assignments, and both Container Apps.

The backend stores sensitive values as Container App secrets:

- `MONGO_URI`
- `JWT_SECRET_KEY`
- `STREAM_API_KEY`
- `STREAM_API_SECRET`

The frontend requires `VITE_STREAM_API_KEY` at image build time.

## CI/CD

GitHub Actions workflow:

```txt
.github/workflows/azure-container-apps.yml
```

Jobs:

- `ci`: dependency install, frontend lint, frontend build, backend dependency install.
- `cd`: Azure login, ACR provisioning, Docker build/push for both images, Bicep deployment to ACA.

Required GitHub secrets:

```txt
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
MONGO_URI
JWT_SECRET_KEY
STREAM_API_KEY
STREAM_API_SECRET
VITE_STREAM_API_KEY
```

## Local Workflows

Development stays npm-first:

```sh
npm run dev --prefix backend
npm run dev --prefix frontend
```

Full local container verification:

```sh
docker compose up --build
```

## Security Notes

- Backend Container App ingress is internal only.
- Frontend Container App is the only public ingress point.
- ACR admin user is disabled.
- Container Apps pull images using user-assigned managed identities with `AcrPull`.
- GitHub Actions uses Azure OIDC login instead of publish profiles.
