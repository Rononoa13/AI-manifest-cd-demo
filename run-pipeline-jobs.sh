#!/bin/bash

# Simple script to run deployment jobs for each tenant

echo "Starting pipeline execution..."

# Run deploy for tenant1
echo "Running deploy-tenant1..."
TENANT_NAME="tenant1" ENVIRONMENT="staging" TENANT_ID="tenant1" CUSTOM_SETTING="enabled" ./deploy

# Run deploy for tenant2
echo "Running deploy-tenant2..."
TENANT_NAME="tenant2" ENVIRONMENT="production" TENANT_ID="tenant2" CUSTOM_SETTING="disabled" ./deploy

echo "Pipeline execution completed."