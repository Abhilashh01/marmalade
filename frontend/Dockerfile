FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ARG VITE_STREAM_API_KEY
# ENV VITE_STREAM_API_KEY=$VITE_STREAM_API_KEY
RUN npm run build

FROM nginx:1.27-alpine AS runtime
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
