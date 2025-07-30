# IoT Ingestion Framework - Databricks Asset Bundle

This repository contains a production-ready Databricks Asset Bundle (DAB) for IoT data ingestion and processing, following enterprise-grade CI/CD best practices.

## 🏗️ Architecture Overview

```
├── databricks.yml              # Main bundle configuration
├── resources/                  # Resource definitions
│   └── jobs/                   # Job configurations
│       ├── iot_ingestion_job.yml
│       └── config_job.yml
├── notebooks/                  # Notebook source code
│   ├── iot_ingestion/
│   │   ├── api_ingestion_framework.py
│   │   ├── load_data_into_bronze.py
│   │   └── create_final_bronze_table.py
│   └── config/
│       └── create_config_tables.py
├── tests/                      # Unit and integration tests
├── .github/workflows/          # CI/CD automation
│   └── ci-cd.yml
└── requirements.txt            # Python dependencies
```

## 🚀 Getting Started

### Prerequisites

1. **Databricks CLI** (v0.218.0+)
   ```bash
   pip install databricks-cli
   ```

2. **Configure Authentication**
   ```bash
   databricks configure --token
   ```

3. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

### Local Development

1. **Validate Bundle**
   ```bash
   databricks bundle validate
   ```

2. **Deploy to Development**
   ```bash
   databricks bundle deploy --target dev
   ```

3. **Run Jobs**
   ```bash
   databricks bundle run config_tables_job --target dev
   databricks bundle run iot_ingestion_job --target dev
   ```

## 🔄 CI/CD Pipeline

The repository implements a GitOps workflow with the following environments:

### Environment Promotion Flow
```
Feature Branch → develop → main → release tag
     ↓            ↓        ↓         ↓
   Manual      Dev Env   Test Env  Prod Env
```

### Pipeline Stages

1. **Validation** (All branches)
   - Bundle syntax validation
   - Configuration checks across all targets
   - Code linting and security scans

2. **Testing** (Pull requests)
   - Unit tests execution
   - Integration test validation
   - Code quality checks

3. **Development Deployment** (`develop` branch)
   - Automatic deployment to dev environment
   - User-isolated workspace paths
   - Paused job schedules for testing

4. **Test Deployment** (`main` branch)
   - Deployment to shared test environment
   - Smoke tests execution
   - Staging validation

5. **Production Deployment** (Release tags)
   - Manual approval required
   - Production deployment with monitoring
   - Notification and health checks

## 🎯 Environment Configuration

### Development (`dev`)
- **Mode**: `development`
- **Path**: `/Users/{current_user}/.bundle/{bundle_name}/dev`
- **Scheduling**: Paused by default
- **Concurrent runs**: Limited to 1
- **Purpose**: Individual developer testing and iteration

### Test (`test`)
- **Mode**: `development`
- **Path**: `/Shared/bundles/{bundle_name}/test`
- **Scheduling**: Paused by default
- **Concurrent runs**: Limited to 2
- **Purpose**: Integration testing and QA validation

### Production (`prod`)
- **Mode**: `production`
- **Path**: `/Shared/bundles/{bundle_name}/prod`
- **Scheduling**: Active based on cron schedule
- **Concurrent runs**: Up to 5
- **Purpose**: Live data processing

## 🔐 Security & Permissions

### Access Control
- **Data Engineers**: Full management permissions
- **Analysts**: View-only access
- **Production Admins**: Production environment control

### Secret Management
- Use Databricks Secret Scopes for sensitive data
- Environment variables in CI/CD for tokens
- No hardcoded credentials in configuration files

### Resource Tagging
All resources are tagged with:
- `project`: iot-ingestion
- `team`: data-engineering
- `cost_center`: analytics
- `environment`: dev/test/prod

## 📊 Monitoring & Observability

### Job Monitoring
- Email notifications on job failures
- Webhook integration for Slack alerts
- Retry policies with exponential backoff
- Timeout protection for long-running tasks

### Resource Optimization
- Auto-scaling clusters (1-4 workers)
- Delta optimization enabled
- Queue management for resource efficiency
- Environment-specific cluster sizing

## 🧪 Testing Strategy

### Unit Tests
```bash
pytest tests/ -v
```

### Integration Tests
- Bundle validation across environments
- End-to-end pipeline testing
- Data quality validation

### Deployment Validation
- Post-deployment health checks
- Job execution verification
- Data lineage confirmation

## 📝 Development Workflow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/new-iot-source
   ```

2. **Make Changes**
   - Update notebooks in `notebooks/`
   - Modify job configurations in `resources/jobs/`
   - Add tests in `tests/`

3. **Test Locally**
   ```bash
   databricks bundle validate
   databricks bundle deploy --target dev
   ```

4. **Submit Pull Request**
   - CI pipeline validates changes
   - Code review and approval required
   - Automated testing execution

5. **Deploy to Test**
   - Merge to `main` triggers test deployment
   - Staging validation and smoke tests

6. **Release to Production**
   - Create release tag for production deployment
   - Manual approval and monitoring

## 🏷️ Versioning

The project follows [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes to data schemas or APIs
- **MINOR**: New features and backwards-compatible changes
- **PATCH**: Bug fixes and minor improvements

## 🤝 Contributing

1. Follow the established directory structure
2. Add tests for new functionality
3. Update documentation for changes
4. Use descriptive commit messages
5. Request code review before merging

## 📞 Support

For questions and support:
- **Data Engineering Team**: data-engineering@seaspancorp.com
- **Documentation**: [Internal Wiki Link]
- **Issues**: Use GitHub Issues for bug reports and feature requests

## 🔗 Related Resources

- [Databricks Asset Bundles Documentation](https://docs.databricks.com/dev-tools/bundles/)
- [Company Data Engineering Standards](link-to-internal-docs)
- [Unity Catalog Best Practices](link-to-internal-docs) 