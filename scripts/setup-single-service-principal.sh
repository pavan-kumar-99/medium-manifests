#!/bin/bash

# Single Service Principal Setup Script for Databricks CI/CD
# This script creates one service principal with access to all environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - UPDATE THESE VALUES
SUBSCRIPTION_ID=""
RESOURCE_GROUP_DEV=""
RESOURCE_GROUP_TEST=""
RESOURCE_GROUP_PROD=""
DATABRICKS_WORKSPACE_DEV=""
DATABRICKS_WORKSPACE_TEST=""
DATABRICKS_WORKSPACE_PROD=""

echo -e "${BLUE}🚀 Single Service Principal Setup for Databricks CI/CD${NC}"
echo "========================================================="

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

# Function to create single service principal
create_single_service_principal() {
    local sp_name="databricks-cicd-multi-env"
    
    echo -e "\n${BLUE}Creating single service principal for all environments...${NC}"
    
    # Build scopes array
    local scopes=()
    [ -n "$RESOURCE_GROUP_DEV" ] && scopes+=("/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_DEV}")
    [ -n "$RESOURCE_GROUP_TEST" ] && scopes+=("/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_TEST}")
    [ -n "$RESOURCE_GROUP_PROD" ] && scopes+=("/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_PROD}")
    
    if [ ${#scopes[@]} -eq 0 ]; then
        echo -e "${RED}❌ No resource groups configured. Please update the script configuration.${NC}"
        exit 1
    fi
    
    # Create service principal with access to all resource groups
    local sp_output=$(az ad sp create-for-rbac \
        --name "$sp_name" \
        --role contributor \
        --scopes "${scopes[@]}" \
        --output json)
    
    local app_id=$(echo "$sp_output" | jq -r '.appId')
    local client_secret=$(echo "$sp_output" | jq -r '.password')
    local tenant_id=$(echo "$sp_output" | jq -r '.tenant')
    
    echo -e "${GREEN}✅ Service principal created successfully!${NC}"
    echo "   App ID: $app_id"
    echo "   Tenant ID: $tenant_id"
    echo -e "${YELLOW}   Secret: [HIDDEN - save this securely]${NC}"
    
    # Store in file for GitHub secrets setup
    cat > "github-secrets.txt" << EOF
# Service Principal Authentication (Shared)
AZURE_TENANT_ID: $tenant_id
AZURE_CLIENT_ID: $app_id
AZURE_CLIENT_SECRET: $client_secret

EOF

    echo -e "${GREEN}✅ Service principal secrets saved to github-secrets.txt${NC}"
    
    return 0
}

# Function to get workspace resource IDs
get_workspace_resource_ids() {
    echo -e "\n${BLUE}Getting Databricks workspace resource IDs...${NC}"
    
    cat >> "github-secrets.txt" << EOF
# Environment-Specific Workspace Configuration
EOF
    
    # Development workspace
    if [ -n "$RESOURCE_GROUP_DEV" ] && [ -n "$DATABRICKS_WORKSPACE_DEV" ]; then
        local dev_resource_id=$(az resource show \
            --resource-group "$RESOURCE_GROUP_DEV" \
            --name "$DATABRICKS_WORKSPACE_DEV" \
            --resource-type "Microsoft.Databricks/workspaces" \
            --query id -o tsv 2>/dev/null)
        
        if [ -n "$dev_resource_id" ]; then
            echo -e "${GREEN}✅ Development workspace found${NC}"
            cat >> "github-secrets.txt" << EOF
DATABRICKS_HOST_DEV: https://adb-dev-88474350318135.15.azuredatabricks.net
DATABRICKS_WORKSPACE_RESOURCE_ID_DEV: $dev_resource_id
EOF
        else
            echo -e "${YELLOW}⚠️  Development workspace not found: $DATABRICKS_WORKSPACE_DEV${NC}"
        fi
    fi
    
    # Test workspace
    if [ -n "$RESOURCE_GROUP_TEST" ] && [ -n "$DATABRICKS_WORKSPACE_TEST" ]; then
        local test_resource_id=$(az resource show \
            --resource-group "$RESOURCE_GROUP_TEST" \
            --name "$DATABRICKS_WORKSPACE_TEST" \
            --resource-type "Microsoft.Databricks/workspaces" \
            --query id -o tsv 2>/dev/null)
        
        if [ -n "$test_resource_id" ]; then
            echo -e "${GREEN}✅ Test workspace found${NC}"
            cat >> "github-secrets.txt" << EOF
DATABRICKS_HOST_TEST: https://adb-test-88474350318135.15.azuredatabricks.net
DATABRICKS_WORKSPACE_RESOURCE_ID_TEST: $test_resource_id
EOF
        else
            echo -e "${YELLOW}⚠️  Test workspace not found: $DATABRICKS_WORKSPACE_TEST${NC}"
        fi
    fi
    
    # Production workspace
    if [ -n "$RESOURCE_GROUP_PROD" ] && [ -n "$DATABRICKS_WORKSPACE_PROD" ]; then
        local prod_resource_id=$(az resource show \
            --resource-group "$RESOURCE_GROUP_PROD" \
            --name "$DATABRICKS_WORKSPACE_PROD" \
            --resource-type "Microsoft.Databricks/workspaces" \
            --query id -o tsv 2>/dev/null)
        
        if [ -n "$prod_resource_id" ]; then
            echo -e "${GREEN}✅ Production workspace found${NC}"
            cat >> "github-secrets.txt" << EOF
DATABRICKS_HOST_PROD: https://adb-prod-88474350318135.15.azuredatabricks.net
DATABRICKS_WORKSPACE_RESOURCE_ID_PROD: $prod_resource_id
EOF
        else
            echo -e "${YELLOW}⚠️  Production workspace not found: $DATABRICKS_WORKSPACE_PROD${NC}"
        fi
    fi
}

# Function to grant workspace permissions
grant_workspace_permissions() {
    local app_id=$1
    
    echo -e "\n${BLUE}Granting workspace permissions...${NC}"
    
    # Development workspace
    if [ -n "$RESOURCE_GROUP_DEV" ] && [ -n "$DATABRICKS_WORKSPACE_DEV" ]; then
        local dev_resource_id=$(az resource show \
            --resource-group "$RESOURCE_GROUP_DEV" \
            --name "$DATABRICKS_WORKSPACE_DEV" \
            --resource-type "Microsoft.Databricks/workspaces" \
            --query id -o tsv 2>/dev/null)
        
        if [ -n "$dev_resource_id" ]; then
            az role assignment create \
                --assignee "$app_id" \
                --role "Contributor" \
                --scope "$dev_resource_id" > /dev/null 2>&1
            echo -e "${GREEN}✅ Granted permissions to development workspace${NC}"
        fi
    fi
    
    # Test workspace
    if [ -n "$RESOURCE_GROUP_TEST" ] && [ -n "$DATABRICKS_WORKSPACE_TEST" ]; then
        local test_resource_id=$(az resource show \
            --resource-group "$RESOURCE_GROUP_TEST" \
            --name "$DATABRICKS_WORKSPACE_TEST" \
            --resource-type "Microsoft.Databricks/workspaces" \
            --query id -o tsv 2>/dev/null)
        
        if [ -n "$test_resource_id" ]; then
            az role assignment create \
                --assignee "$app_id" \
                --role "Contributor" \
                --scope "$test_resource_id" > /dev/null 2>&1
            echo -e "${GREEN}✅ Granted permissions to test workspace${NC}"
        fi
    fi
    
    # Production workspace
    if [ -n "$RESOURCE_GROUP_PROD" ] && [ -n "$DATABRICKS_WORKSPACE_PROD" ]; then
        local prod_resource_id=$(az resource show \
            --resource-group "$RESOURCE_GROUP_PROD" \
            --name "$DATABRICKS_WORKSPACE_PROD" \
            --resource-type "Microsoft.Databricks/workspaces" \
            --query id -o tsv 2>/dev/null)
        
        if [ -n "$prod_resource_id" ]; then
            az role assignment create \
                --assignee "$app_id" \
                --role "Contributor" \
                --scope "$prod_resource_id" > /dev/null 2>&1
            echo -e "${GREEN}✅ Granted permissions to production workspace${NC}"
        fi
    fi
}

# Main setup function
main() {
    echo -e "\n${YELLOW}📋 Configuration Check:${NC}"
    echo "Please update the variables at the top of this script:"
    echo "- SUBSCRIPTION_ID (current: $SUBSCRIPTION_ID)"
    echo "- RESOURCE_GROUP_DEV: $RESOURCE_GROUP_DEV"
    echo "- RESOURCE_GROUP_TEST: $RESOURCE_GROUP_TEST"
    echo "- RESOURCE_GROUP_PROD: $RESOURCE_GROUP_PROD"
    echo "- DATABRICKS_WORKSPACE_DEV: $DATABRICKS_WORKSPACE_DEV"
    echo "- DATABRICKS_WORKSPACE_TEST: $DATABRICKS_WORKSPACE_TEST"
    echo "- DATABRICKS_WORKSPACE_PROD: $DATABRICKS_WORKSPACE_PROD"
    
    if [ -z "$RESOURCE_GROUP_DEV" ] && [ -z "$RESOURCE_GROUP_TEST" ] && [ -z "$RESOURCE_GROUP_PROD" ]; then
        echo -e "\n${RED}❌ Please configure at least one resource group at the top of this script.${NC}"
        exit 1
    fi
    
    # Clean up old files
    rm -f github-secrets.txt
    
    echo -e "\n${BLUE}🔧 Creating single service principal...${NC}"
    create_single_service_principal
    
    # Extract app ID for permission granting
    local app_id=$(grep "AZURE_CLIENT_ID:" github-secrets.txt | cut -d':' -f2 | tr -d ' ')
    
    echo -e "\n${BLUE}🔐 Getting workspace information...${NC}"
    get_workspace_resource_ids
    
    echo -e "\n${BLUE}🔐 Granting workspace permissions...${NC}"
    grant_workspace_permissions "$app_id"
    
    echo -e "\n${GREEN}🎉 Setup completed successfully!${NC}"
    echo -e "\n${YELLOW}📋 Next steps:${NC}"
    echo "1. Review the generated file: github-secrets.txt"
    echo "2. Add these secrets to your GitHub repository:"
    echo "   - Go to GitHub repository → Settings → Secrets and variables → Actions"
    echo "   - Add each secret from github-secrets.txt"
    echo "3. Add service principal to Databricks workspaces:"
    echo "   - Log into each workspace (dev, test, prod)"
    echo "   - Go to Settings → Identity and access"
    echo "   - Add service principal using App ID: $app_id"
    echo "   - Grant appropriate permissions (Admin for CI/CD)"
    echo "4. Test the setup:"
    echo "   - Run: databricks bundle validate --target dev"
    echo "   - Run: databricks bundle validate --target test"
    echo "   - Run: databricks bundle validate --target prod"
    
    echo -e "\n${RED}⚠️  Important Security Notes:${NC}"
    echo "- Store the client secret securely"
    echo "- Delete github-secrets.txt after adding secrets to GitHub"
    echo "- The service principal has Contributor role on all configured workspaces"
    echo "- Consider rotating the secret every 6 months"
    
    echo -e "\n${BLUE}📄 Generated secrets file:${NC}"
    cat github-secrets.txt
}

# Run main function
main "$@" 