#!/bin/bash

# User credentials
export CLIENT_LOGIN_EMAIL="daviemericko@gmail.com"
export CLIENT_LOGIN_PASSWORD_HASH='$2b$10$HqfozApCUbsLifSlhig9yOkjZDj4cXDHIrGVRzO4mEl5OAu1IMkLS'
export CLIENT_USER_NAME="Davi Emerick"
export CLIENT_COMPANY_NAME="Sua Empresa"
export CLIENT_PLAN_TYPE="pro"

# JWT and Session Secrets
export JWT_SECRET="demo-secret-key-for-development-only"
export SESSION_SECRET="default-dev-secret-change-in-production"

# Start the integrated server (includes Vite middleware + Express backend)
echo "Starting integrated server (Express + Vite) on port 5000..."
echo "User configured: $CLIENT_LOGIN_EMAIL"
PORT=5000 NODE_ENV=development tsx server/index.ts
