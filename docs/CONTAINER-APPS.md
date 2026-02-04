# Container Apps Deployment (Azure)

## Goal
Document a two-container deployment to Azure Container Apps to demonstrate containerization, service-to-service communication, and production-style configuration.

## Architecture
- Frontend container: React build served by a web server (e.g., Nginx)
- Backend container: Node/Express API
- Communication: Frontend -> Backend via `VITE_API_BASE_URL`
- CORS: Backend allows the frontend container URL

## Local Dev (Docker Compose)
- Prereqs: Docker Desktop
- Required `.env` values
- Build and run commands

## Azure Container Apps Steps
1. Build and push images
2. Create Container Apps environment
3. Deploy backend container (enable ingress)
4. Deploy frontend container (set `VITE_API_BASE_URL` to backend URL)
5. Verify routing, CORS, and API health

## Troubleshooting
- CORS errors
- Wrong API base URL
- Container image pull failures

## Cost Notes
This deployment is intended for demonstration and documentation. The container apps may be stopped to avoid ongoing costs and restarted when needed.
