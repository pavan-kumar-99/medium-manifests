# GitHub Secrets Setup for Single Service Principal Authentication

This document explains how to configure GitHub repository secrets for environment-specific Databricks Asset Bundle deployments using a **single Azure Service Principal** across all environments (simplified approach).

## 🔐 Required GitHub Secrets

You need to configure the following secrets in your GitHub repository settings:

### **Service Principal Authentication (Shared)**
- `AZURE_TENANT_ID`: Your Azure Active Directory tenant ID
- `AZURE_CLIENT_ID`: Service principal application (client) ID
- `AZURE_CLIENT_SECRET`: Service principal client secret

### **Environment-Specific Workspace Configuration**
- `DATABRICKS_HOST_DEV`: Development Databricks workspace URL
- `DATABRICKS_HOST_TEST`: Test/Staging Databricks workspace URL
- `DATABRICKS_HOST_PROD`: Production Databricks workspace URL
- `DATABRICKS_WORKSPACE_RESOURCE_ID_DEV`: Azure resource ID for dev workspace
- `DATABRICKS_WORKSPACE_RESOURCE_ID_TEST`: Azure resource ID for test workspace
- `DATABRICKS_WORKSPACE_RESOURCE_ID_PROD`: Azure resource ID for production workspace

## 🏗️ Current Workspace Configuration

Based on your targets configuration:

| Environment | Databricks Host | Purpose |
|-------------|----------------|---------|
| **Development** | `https://adb-dev-88474350318135.15.azuredatabricks.net` | Individual developer testing |
| **Test** | `https://adb-test-88474350318135.15.azuredatabricks.net` | Integration testing and QA |
| **Production** | `https://adb-prod-88474350318135.15.azuredatabricks.net` | Live production workloads |

## 🛠️ Single Service Principal Setup Guide

### Step 1: Create a Single Service Principal

Create one service principal with access to all workspace resource groups:

```bash
# Create service principal with contributor access to all resource groups
az ad sp create-for-rbac --name "databricks-cicd-multi-env" \
  --role contributor \
  --scopes "/subscriptions/{subscription-id}/resourceGroups/{dev-resource-group}" \
           "/subscriptions/{subscription-id}/resourceGroups/{test-resource-group}" \
           "/subscriptions/{subscription-id}/resourceGroups/{prod-resource-group}" \
  --output json
```

This will output:
```json
{
  "appId": "12345678-1234-1234-1234-123456789012",
  "displayName": "databricks-cicd-multi-env",
  "password": "your-client-secret",
  "tenant": "87654321-4321-4321-4321-210987654321"
}
```

### Step 2: Grant Databricks Workspace Permissions

Add the service principal to each Databricks workspace:

#### Add to Databricks Workspaces (Manual):
1. **Log into each Databricks workspace** (dev, test, prod)
2. **Go to Settings** → **Identity and access**
3. **Add the service principal**:
   - Use the `appId` from the Azure CLI output: `12345678-1234-1234-1234-123456789012`
   - Grant appropriate permissions (Admin for CI/CD, or custom roles)

#### Grant Azure Resource Permissions (Automated):
```bash
# Get workspace resource IDs
DEV_WORKSPACE_ID=$(az resource show --resource-group {dev-rg} --name {dev-workspace} \
  --resource-type "Microsoft.Databricks/workspaces" --query id -o tsv)

TEST_WORKSPACE_ID=$(az resource show --resource-group {test-rg} --name {test-workspace} \
  --resource-type "Microsoft.Databricks/workspaces" --query id -o tsv)

PROD_WORKSPACE_ID=$(az resource show --resource-group {prod-rg} --name {prod-workspace} \
  --resource-type "Microsoft.Databricks/workspaces" --query id -o tsv)

# Grant contributor access to each workspace
az role assignment create --assignee {service-principal-app-id} --role "Contributor" --scope "$DEV_WORKSPACE_ID"
az role assignment create --assignee {service-principal-app-id} --role "Contributor" --scope "$TEST_WORKSPACE_ID"
az role assignment create --assignee {service-principal-app-id} --role "Contributor" --scope "$PROD_WORKSPACE_ID"
```

### Step 3: Configure GitHub Secrets

#### Access Repository Settings
1. Go to your GitHub repository
2. Click on **Settings** tab
3. Navigate to **Secrets and variables** → **Actions**

#### Add Required Secrets

##### Service Principal Secrets (Shared)
```
Name: AZURE_TENANT_ID
Value: 87654321-4321-4321-4321-210987654321

Name: AZURE_CLIENT_ID
Value: 12345678-1234-1234-1234-123456789012

Name: AZURE_CLIENT_SECRET
Value: your-service-principal-secret
```

##### Workspace-Specific Secrets
```
Name: DATABRICKS_HOST_DEV
Value: https://adb-dev-88474350318135.15.azuredatabricks.net

Name: DATABRICKS_HOST_TEST
Value: https://adb-test-88474350318135.15.azuredatabricks.net

Name: DATABRICKS_HOST_PROD
Value: https://adb-prod-88474350318135.15.azuredatabricks.net

Name: DATABRICKS_WORKSPACE_RESOURCE_ID_DEV
Value: /subscriptions/{sub-id}/resourceGroups/{dev-rg}/providers/Microsoft.Databricks/workspaces/{dev-workspace}

Name: DATABRICKS_WORKSPACE_RESOURCE_ID_TEST
Value: /subscriptions/{sub-id}/resourceGroups/{test-rg}/providers/Microsoft.Databricks/workspaces/{test-workspace}

Name: DATABRICKS_WORKSPACE_RESOURCE_ID_PROD
Value: /subscriptions/{sub-id}/resourceGroups/{prod-rg}/providers/Microsoft.Databricks/workspaces/{prod-workspace}
```

## 🔍 Finding Required Information

### Azure Tenant ID
```bash
az account show --query tenantId -o tsv
```

### Databricks Workspace Resource IDs
```bash
# Development workspace
az resource show \
  --resource-group {dev-resource-group} \
  --name {dev-databricks-workspace-name} \
  --resource-type "Microsoft.Databricks/workspaces" \
  --query id -o tsv

# Test workspace
az resource show \
  --resource-group {test-resource-group} \
  --name {test-databricks-workspace-name} \
  --resource-type "Microsoft.Databricks/workspaces" \
  --query id -o tsv

# Production workspace
az resource show \
  --resource-group {prod-resource-group} \
  --name {prod-databricks-workspace-name} \
  --resource-type "Microsoft.Databricks/workspaces" \
  --query id -o tsv
```

## 🔒 Security Considerations

### **Benefits of Single Service Principal**
- ✅ **Simplified management**: One set of credentials to manage
- ✅ **Easier rotation**: Single secret to rotate across all environments
- ✅ **Reduced complexity**: Fewer secrets to configure and maintain
- ✅ **Consistent permissions**: Same identity across all environments

### **Potential Limitations**
- ⚠️ **Less granular control**: Same permissions across all environments
- ⚠️ **Broader blast radius**: If compromised, affects all environments
- ⚠️ **Audit trail**: Harder to distinguish actions between environments

### **Mitigation Strategies**
- ✅ **Use workspace-level permissions**: Configure different permissions within each workspace
- ✅ **Regular secret rotation**: Rotate service principal secrets every 6 months
- ✅ **Monitor usage**: Set up alerts for unusual activity
- ✅ **Use Azure Key Vault**: Store secrets in Key Vault with access policies

## 🎯 Benefits vs. Multi-Service Principal Approach

| Aspect | Single Service Principal | Multiple Service Principals |
|--------|-------------------------|----------------------------|
| **Setup Complexity** | ✅ Simple | ⚠️ Complex |
| **Management Overhead** | ✅ Low | ⚠️ High |
| **Security Isolation** | ⚠️ Limited | ✅ High |
| **Audit Granularity** | ⚠️ Limited | ✅ Detailed |
| **Secret Rotation** | ✅ Simple | ⚠️ Complex |
| **Compliance** | ⚠️ May not meet strict requirements | ✅ Meets enterprise requirements |

## 📞 Troubleshooting

### **Common Issues**

1. **"Authentication failed"**
   ```bash
   # Test authentication locally
   az login --service-principal -u {client-id} -p {client-secret} --tenant {tenant-id}
   ```

2. **"Insufficient permissions"**
   - Check service principal has Contributor role on all workspace resources
   - Verify service principal is added to all Databricks workspaces
   - Ensure workspace resource IDs are correct

3. **"Workspace not found"**
   - Verify workspace resource ID format for each environment
   - Check if workspaces exist in specified subscription/resource groups

### **Testing Service Principal Authentication**

Test locally before setting up CI/CD:

```bash
# Set environment variables for development
export DATABRICKS_HOST="https://adb-dev-88474350318135.15.azuredatabricks.net"
export DATABRICKS_AZURE_WORKSPACE_RESOURCE_ID="/subscriptions/{sub}/resourceGroups/{dev-rg}/providers/Microsoft.Databricks/workspaces/{dev-workspace}"
export DATABRICKS_AZURE_CLIENT_ID="12345678-1234-1234-1234-123456789012"
export DATABRICKS_AZURE_CLIENT_SECRET="your-client-secret"
export DATABRICKS_AZURE_TENANT_ID="87654321-4321-4321-4321-210987654321"

# Test bundle validation for each environment
databricks bundle validate --target dev
databricks bundle validate --target test
databricks bundle validate --target prod
```

## 📋 Simplified Setup Checklist

- [ ] Create single service principal with multi-resource group access
- [ ] Add service principal to all Databricks workspaces
- [ ] Grant Azure resource permissions to all workspaces
- [ ] Configure GitHub repository secrets (3 shared + 6 workspace-specific)
- [ ] Test authentication locally for all environments
- [ ] Test CI/CD pipeline deployment

## 🚀 Alternative: Even Simpler Single Workspace

If using a single Databricks workspace for all environments (not recommended for production):

```yaml
# Minimal GitHub Secrets
AZURE_TENANT_ID: your-tenant-id
AZURE_CLIENT_ID: your-client-id
AZURE_CLIENT_SECRET: your-client-secret
DATABRICKS_HOST: https://adb-88474350318135.15.azuredatabricks.net
DATABRICKS_WORKSPACE_RESOURCE_ID: /subscriptions/.../workspace-id
```

This setup provides a good balance between simplicity and environment isolation for most organizations. 