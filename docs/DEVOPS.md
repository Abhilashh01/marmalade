# DevOps and Cloud Notes

This document highlights the infrastructure, deployment, and operational work for Marmalade. The frontend is treated as a static build artifact; the focus here is backend, cloud, and DevOps.

## Overview
- Backend: Node.js/Express API with MongoDB and JWT auth
- Realtime: Stream Chat + Stream Video
- Deployment target(s): Azure App Service and Azure Container Apps

## Infrastructure
- MongoDB: Atlas or self-hosted
- Secrets: GitHub Actions secrets and app environment variables
- Environments: Development and Production

## CI/CD
- GitHub Actions workflow builds the frontend and packages the backend for deployment
- Deployment via Azure Web Apps publish profile
- Optional path: Azure login with service principal (more secure, fine-grained access)

## Azure App Service Deployment
- Backend serves the built frontend in production
- Deployment artifact: `marmalade.zip`
- Environment variables provided via App Service configuration

## Azure Container Apps Deployment (Two Containers)
- Frontend container: serves built React app
- Backend container: Express API
- Communication: `VITE_API_BASE_URL` -> backend ingress URL
- CORS: backend allows frontend origin
- Documented in: `docs/CONTAINER-APPS.md`

## Observability and Ops (Planned/Optional)
- Health checks for API readiness/liveness
- Log streaming from Azure
- Basic alerting for downtime (optional)

## Security Considerations
- Secrets stored in GitHub Actions and Azure App Service configuration
- JWT secret required for auth
- Least-privilege service principal recommended for production-grade setups

## Cost and Lifecycle
- App Service is used for the always-on demo
- Container Apps are used for documented, on-demand demos and can be stopped to reduce cost
