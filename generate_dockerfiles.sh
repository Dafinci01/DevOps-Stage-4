#!/bin/bash 

#define ddockerfile template for each service 


declare -A dockerfileContent


dockerfileContent dockerfileContent["auth-api"]=$(cat <<'EOF'
# Dockerfile for Auth API (Go)
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go mod download && go build -o auth-api .
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/auth-api .
CMD ["./auth-api"]
EOF
)

dockerfileContent["frontend"]=$(cat <<'EOF'
# Dockerfile for Frontend (Vue.js)
FROM node:18 AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:latest AS production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF
)

dockerfileContent["log-message-processor"]=$(cat <<'EOF'
# Dockerfile for Log Message Processor (Python)
FROM python:3.11
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "main.py"]
EOF
)

dockerfileContent["todos-api"]=$(cat <<'EOF'
# Dockerfile for Todos API (Node.js)
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
EOF
)

dockerfileContent["users-api"]=$(cat <<'EOF'
# Dockerfile for Users API (Java/Spring Boot)
# Assumes you have already built a jar file in the 'target' folder.
FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
EOF
)

# Loop through the defined services and generate Dockerfiles if the directory exists.
for service in "${!dockerfileContent[@]}"; do
    if [ -d "$service" ]; then
        echo "Generating Dockerfile for $service..."
        echo "${dockerfileContent[$service]}" > "$service/Dockerfile"
        echo "Dockerfile generated for $service."
    else
        echo "Directory '$service' does not exist. Skipping..."
    fi
done

echo "All Dockerfiles have been generated."

