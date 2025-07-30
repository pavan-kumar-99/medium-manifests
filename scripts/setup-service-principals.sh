#!/bin/bash

# Service Principal Setup Script for Databricks CI/CD
# This script helps create and configure service principals for each environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SUBSCRIPTION_ID=""
RESOURCE_GROUP_DEV=""
RESOURCE_GROUP_TEST=""
RESOURCE_GROUP_PROD=""
DATABRICKS_WORKSPACE_DEV=""
DATABRICKS_WORKSPACE_TEST=""
DATABRICKS_WORKSPACE_PROD=""

echo -e "${BLUE}🚀 Databricks Service Principal Setup${NC}"
echo "======================================"

# Check if Azure CLI is installed and logged in
if ! command -v az &> /dev/null; then
    echo -e "${RED}❌ Azure CLI is not installed. Please install it first.${NC}"
    exit 1
fi

if ! az account show &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged into Azure. Please run 'az login' first.${NC}"
    exit 1
fi

# Get current subscription info
if [ -z "$SUBSCRIPTION_ID" ]; then
    SUBSCRIPTION_ID=$(az account show --query id -o tsv)
    echo -e "${GREEN}✅ Using subscription: $SUBSCRIPTION_ID${NC}"
fi

# Function to create service principal
create_service_principal() {
    local env_name=$1
    local resource_group=$2
    local sp_name="databricks-cicd-${env_name}"
    
    echo -e "\n${BLUE}Creating service principal for ${env_name} environment...${NC}"
    
    # Create service principal
    local sp_output=$(az ad sp create-for-rbac \
        --name "$sp_name" \
        --role contributor \
        --scopes "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${resource_group}" \
        --output json)
    
    local app_id=$(echo "$sp_output" | jq -r '.appId')
    local client_secret=$(echo "$sp_output" | jq -r '.password')
    local tenant_id=$(echo "$sp_output" | jq -r '.tenant')
    
    echo -e "${GREEN}✅ Service principal created for ${env_name}${NC}"
    echo "   App ID: $app_id"
    echo "   Tenant ID: $tenant_id"
    echo -e "${YELLOW}   Secret: [HIDDEN - save this securely]${NC}"
    
    # Store in file for GitHub secrets setup
    cat >> "service-principals-${env_name}.txt" << EOF
# ${env_name} Environment Service Principal
AZURE_CLIENT_ID_${env_name^^}: $app_id
AZURE_CLIENT_SECRET_${env_name^^}: $client_secret
AZURE_TENANT_ID: $tenant_id

EOF

    echo -e "${GREEN}✅ Secrets saved to service-principals-${env_name}.txt${NC}"
    
    return 0
}

# Function to grant Databricks workspace permissions
grant_databricks_permissions() {
    local env_name=$1
    local workspace_name=$2
    local resource_group=$3
    local app_id=$4
    
    echo -e "\n${BLUE}Granting Databricks permissions for ${env_name}...${NC}"
    
    # Get workspace resource ID
    local workspace_resource_id=$(az resource show \
        --resource-group "$resource_group" \
        --name "$workspace_name" \
        --resource-type "Microsoft.Databricks/workspaces" \
        --query id -o tsv)
    
    if [ -z "$workspace_resource_id" ]; then
        echo -e "${RED}❌ Could not find workspace: $workspace_name${NC}"
        return 1
    fi
    
    # Grant contributor access to workspace
    az role assignment create \
        --assignee "$app_id" \
        --role "Contributor" \
        --scope "$workspace_resource_id" > /dev/null
    
    echo -e "${GREEN}✅ Granted Contributor role to workspace${NC}"
    echo "   Workspace: $workspace_name"
    echo "   Resource ID: $workspace_resource_id"
    
    # Save workspace resource ID for GitHub secrets
    cat >> "workspace-resource-ids.txt" << EOF
DATABRICKS_WORKSPACE_RESOURCE_ID_${env_name^^}: $workspace_resource_id
EOF
    
    return 0
}

# Main setup function
main() {
    echo -e "\n${YELLOW}📋 Configuration needed:${NC}"
    echo "Please update the variables at the top of this script with your values:"
    echo "- SUBSCRIPTION_ID (current: $SUBSCRIPTION_ID)"
    echo "- RESOURCE_GROUP_DEV, RESOURCE_GROUP_TEST, RESOURCE_GROUP_PROD"
    echo "- DATABRICKS_WORKSPACE_DEV, DATABRICKS_WORKSPACE_TEST, DATABRICKS_WORKSPACE_PROD"
    
    if [ -z "$RESOURCE_GROUP_DEV" ] || [ -z "$DATABRICKS_WORKSPACE_DEV" ]; then
        echo -e "\n${RED}❌ Please configure the variables at the top of this script first.${NC}"
        exit 1
    fi
    
    # Clean up old files
    rm -f service-principals-*.txt workspace-resource-ids.txt
    
    echo -e "\n${BLUE}🔧 Creating service principals...${NC}"
    
    # Create service principals for each environment
    echo -e "\n${YELLOW}1. Development Environment${NC}"
    create_service_principal "dev" "$RESOURCE_GROUP_DEV"
    DEV_APP_ID=$(tail -n 4 service-principals-dev.txt | grep AZURE_CLIENT_ID_DEV | cut -d':' -f2 | tr -d ' ')
    
    echo -e "\n${YELLOW}2. Test Environment${NC}"
    create_service_principal "test" "$RESOURCE_GROUP_TEST"
    TEST_APP_ID=$(tail -n 4 service-principals-test.txt | grep AZURE_CLIENT_ID_TEST | cut -d':' -f2 | tr -d ' ')
    
    echo -e "\n${YELLOW}3. Production Environment${NC}"
    create_service_principal "prod" "$RESOURCE_GROUP_PROD"
    PROD_APP_ID=$(tail -n 4 service-principals-prod.txt | grep AZURE_CLIENT_ID_PROD | cut -d':' -f2 | tr -d ' ')
    
    echo -e "\n${BLUE}🔐 Granting Databricks permissions...${NC}"
    
    # Grant permissions to each workspace
    grant_databricks_permissions "dev" "$DATABRICKS_WORKSPACE_DEV" "$RESOURCE_GROUP_DEV" "$DEV_APP_ID"
    grant_databricks_permissions "test" "$DATABRICKS_WORKSPACE_TEST" "$RESOURCE_GROUP_TEST" "$TEST_APP_ID"
    grant_databricks_permissions "prod" "$DATABRICKS_WORKSPACE_PROD" "$RESOURCE_GROUP_PROD" "$PROD_APP_ID"
    
    echo -e "\n${GREEN}🎉 Setup completed successfully!${NC}"
    echo -e "\n${YELLOW}📋 Next steps:${NC}"
    echo "1. Review the generated files: service-principals-*.txt and workspace-resource-ids.txt"
    echo "2. Add these secrets to your GitHub repository:"
    echo "   - Go to Settings → Secrets and variables → Actions"
    echo "   - Add each secret from the generated files"
    echo "3. Add service principals to Databricks workspaces:"
    echo "   - Log into each workspace"
    echo "   - Go to Settings → Identity and access"
    echo "   - Add service principals using their App IDs"
    echo "4. Test the setup with: databricks bundle validate --target dev"
    
    echo -e "\n${RED}⚠️  Important:${NC}"
    echo "- Store the client secrets securely"
    echo "- Delete the generated files after adding secrets to GitHub"
    echo "- The service principals have been created with Contributor role"
}

# Run main function
main "$@" 