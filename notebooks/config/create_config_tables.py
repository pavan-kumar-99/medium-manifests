# Databricks notebook source
# MAGIC %md
# MAGIC # Create Configuration Tables
# MAGIC 
# MAGIC This notebook creates configuration tables for the IoT ingestion framework.
# MAGIC 
# MAGIC ## Parameters
# MAGIC - `catalog`: Target Unity Catalog
# MAGIC - `environment`: Deployment environment (dev/test/prod)
# MAGIC - `schema`: Target schema name (default: config)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Setup and Configuration

# COMMAND ----------

# Import required libraries
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

# COMMAND ----------

# Get parameters
dbutils.widgets.text("catalog", "dev_test", "Target Catalog")
dbutils.widgets.text("environment", "dev", "Environment")
dbutils.widgets.text("schema", "config", "Target Schema")

catalog = dbutils.widgets.get("catalog")
environment = dbutils.widgets.get("environment")
schema = dbutils.widgets.get("schema")

print(f"Target Catalog: {catalog}")
print(f"Environment: {environment}")
print(f"Target Schema: {schema}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Create Configuration Schema

# COMMAND ----------

# Create config schema if not exists
config_schema = f"{catalog}.{schema}"
spark.sql(f"CREATE SCHEMA IF NOT EXISTS {config_schema}")
print(f"Configuration schema created: {config_schema}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Configuration Tables Definition

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Device Configuration Table

# COMMAND ----------

# Create device configuration table
device_config_table = f"{config_schema}.device_config"

print(f"Creating device configuration table: {device_config_table}")

# Define device configuration data
device_config_data = [
    ("device_001", "Temperature Sensor", "indoor", "Building A - Floor 1", "active", 30, 22.0, 25.0, 45.0, 65.0),
    ("device_002", "Temperature Sensor", "indoor", "Building A - Floor 2", "active", 30, 20.0, 24.0, 40.0, 60.0),
    ("device_003", "Temperature Sensor", "outdoor", "Parking Lot", "active", 60, -10.0, 40.0, 20.0, 80.0),
    ("device_004", "Humidity Sensor", "indoor", "Server Room", "active", 15, 18.0, 22.0, 35.0, 45.0),
    ("device_005", "Pressure Sensor", "outdoor", "Weather Station", "maintenance", 120, -20.0, 50.0, 0.0, 100.0),
]

device_config_schema = StructType([
    StructField("device_id", StringType(), False),
    StructField("device_type", StringType(), False),
    StructField("location_type", StringType(), False),
    StructField("location_description", StringType(), True),
    StructField("status", StringType(), False),
    StructField("data_collection_interval_seconds", IntegerType(), False),
    StructField("min_temperature_threshold", DoubleType(), True),
    StructField("max_temperature_threshold", DoubleType(), True),
    StructField("min_humidity_threshold", DoubleType(), True),
    StructField("max_humidity_threshold", DoubleType(), True)
])

device_config_df = spark.createDataFrame(device_config_data, device_config_schema) \
    .withColumn("created_timestamp", current_timestamp()) \
    .withColumn("updated_timestamp", current_timestamp()) \
    .withColumn("environment", lit(environment))

# Write device configuration table
device_config_df.write \
    .mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(device_config_table)

print(f"Device configuration table created with {device_config_df.count()} records")

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2. Data Quality Rules Table

# COMMAND ----------

# Create data quality rules table
dq_rules_table = f"{config_schema}.data_quality_rules"

print(f"Creating data quality rules table: {dq_rules_table}")

# Define data quality rules
dq_rules_data = [
    ("temperature_range", "temperature_celsius", "range_check", "-50,100", "high", "Temperature must be between -50°C and 100°C", True),
    ("humidity_range", "humidity_percent", "range_check", "0,100", "high", "Humidity must be between 0% and 100%", True),
    ("pressure_range", "pressure_hpa", "range_check", "800,1200", "medium", "Pressure must be between 800 and 1200 hPa", True),
    ("battery_range", "battery_level_percent", "range_check", "0,100", "medium", "Battery level must be between 0% and 100%", True),
    ("device_id_null", "device_id", "null_check", "", "high", "Device ID cannot be null", True),
    ("timestamp_null", "measurement_timestamp", "null_check", "", "high", "Measurement timestamp cannot be null", True),
    ("future_timestamp", "measurement_timestamp", "temporal_check", "future", "medium", "Measurement timestamp cannot be in the future", True),
    ("temperature_outlier", "temperature_celsius", "statistical_check", "3_sigma", "low", "Temperature values beyond 3 standard deviations", True),
    ("duplicate_measurement", "device_id,measurement_timestamp", "duplicate_check", "", "medium", "Duplicate measurements for same device and timestamp", True),
]

dq_rules_schema = StructType([
    StructField("rule_name", StringType(), False),
    StructField("column_name", StringType(), False),
    StructField("rule_type", StringType(), False),
    StructField("rule_parameters", StringType(), True),
    StructField("severity", StringType(), False),
    StructField("description", StringType(), True),
    StructField("is_active", BooleanType(), False)
])

dq_rules_df = spark.createDataFrame(dq_rules_data, dq_rules_schema) \
    .withColumn("created_timestamp", current_timestamp()) \
    .withColumn("updated_timestamp", current_timestamp()) \
    .withColumn("environment", lit(environment))

# Write data quality rules table
dq_rules_df.write \
    .mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(dq_rules_table)

print(f"Data quality rules table created with {dq_rules_df.count()} records")

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3. Processing Configuration Table

# COMMAND ----------

# Create processing configuration table
processing_config_table = f"{config_schema}.processing_config"

print(f"Creating processing configuration table: {processing_config_table}")

# Define processing configuration
processing_config_data = [
    ("api_ingestion", "batch_size", "1000", "Number of records to process in each batch"),
    ("api_ingestion", "timeout_seconds", "300", "API call timeout in seconds"),
    ("api_ingestion", "retry_attempts", "3", "Number of retry attempts for failed API calls"),
    ("api_ingestion", "retry_delay_seconds", "30", "Delay between retry attempts"),
    ("data_processing", "checkpoint_location", "/tmp/checkpoints", "Checkpoint location for streaming jobs"),
    ("data_processing", "max_files_per_trigger", "10", "Maximum files to process per trigger"),
    ("data_processing", "enable_data_quality_checks", "true", "Enable comprehensive data quality validation"),
    ("bronze_layer", "optimization_frequency", "daily", "Frequency for table optimization"),
    ("bronze_layer", "retention_days", "90", "Data retention period in days"),
    ("notifications", "email_on_failure", "true", "Send email notifications on job failures"),
    ("notifications", "slack_webhook_enabled", "true", "Enable Slack webhook notifications"),
    ("monitoring", "enable_metrics_collection", "true", "Enable metrics collection for monitoring"),
    ("monitoring", "metrics_collection_interval", "60", "Metrics collection interval in seconds"),
]

processing_config_schema = StructType([
    StructField("component", StringType(), False),
    StructField("parameter_name", StringType(), False),
    StructField("parameter_value", StringType(), False),
    StructField("description", StringType(), True)
])

processing_config_df = spark.createDataFrame(processing_config_data, processing_config_schema) \
    .withColumn("created_timestamp", current_timestamp()) \
    .withColumn("updated_timestamp", current_timestamp()) \
    .withColumn("environment", lit(environment))

# Write processing configuration table
processing_config_df.write \
    .mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(processing_config_table)

print(f"Processing configuration table created with {processing_config_df.count()} records")

# COMMAND ----------

# MAGIC %md
# MAGIC ### 4. Environment Configuration Table

# COMMAND ----------

# Create environment configuration table
env_config_table = f"{config_schema}.environment_config"

print(f"Creating environment configuration table: {env_config_table}")

# Define environment-specific configuration
env_config_data = [
    (environment, "cluster_config", "node_type", "Standard_DS3_v2", f"Default node type for {environment}"),
    (environment, "cluster_config", "min_workers", "1" if environment == "dev" else "2", f"Minimum workers for {environment}"),
    (environment, "cluster_config", "max_workers", "2" if environment == "dev" else "8", f"Maximum workers for {environment}"),
    (environment, "storage_config", "checkpoint_location", f"/tmp/checkpoints/{environment}", f"Checkpoint location for {environment}"),
    (environment, "storage_config", "data_location", f"/delta/{environment}", f"Data storage location for {environment}"),
    (environment, "job_config", "max_concurrent_runs", "1" if environment == "dev" else "5", f"Max concurrent job runs for {environment}"),
    (environment, "job_config", "timeout_minutes", "60" if environment == "dev" else "120", f"Job timeout for {environment}"),
    (environment, "notification_config", "email_recipients", "data-engineering@seaspancorp.com", f"Email recipients for {environment}"),
    (environment, "monitoring_config", "enable_detailed_logging", "true" if environment != "prod" else "false", f"Detailed logging for {environment}"),
]

env_config_schema = StructType([
    StructField("environment", StringType(), False),
    StructField("config_category", StringType(), False),
    StructField("config_name", StringType(), False),
    StructField("config_value", StringType(), False),
    StructField("description", StringType(), True)
])

env_config_df = spark.createDataFrame(env_config_data, env_config_schema) \
    .withColumn("created_timestamp", current_timestamp()) \
    .withColumn("updated_timestamp", current_timestamp())

# Write environment configuration table
env_config_df.write \
    .mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(env_config_table)

print(f"Environment configuration table created with {env_config_df.count()} records")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Create Configuration Views

# COMMAND ----------

# Create a unified configuration view
unified_config_view = f"{config_schema}.unified_config_view"

spark.sql(f"""
CREATE OR REPLACE VIEW {unified_config_view} AS
SELECT 
    'device_config' as config_type,
    device_id as config_key,
    CONCAT('Device: ', device_type, ' (', location_description, ')') as config_description,
    status as config_status,
    environment,
    created_timestamp,
    updated_timestamp
FROM {device_config_table}

UNION ALL

SELECT 
    'data_quality_rules' as config_type,
    rule_name as config_key,
    description as config_description,
    CASE WHEN is_active THEN 'active' ELSE 'inactive' END as config_status,
    environment,
    created_timestamp,
    updated_timestamp
FROM {dq_rules_table}

UNION ALL

SELECT 
    'processing_config' as config_type,
    CONCAT(component, '.', parameter_name) as config_key,
    description as config_description,
    'active' as config_status,
    environment,
    created_timestamp,
    updated_timestamp
FROM {processing_config_table}

UNION ALL

SELECT 
    'environment_config' as config_type,
    CONCAT(config_category, '.', config_name) as config_key,
    description as config_description,
    'active' as config_status,
    environment,
    created_timestamp,
    updated_timestamp
FROM {env_config_table}
""")

print(f"Unified configuration view created: {unified_config_view}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Validate Configuration Tables

# COMMAND ----------

# Show configuration summary
print("=== CONFIGURATION TABLES SUMMARY ===")

tables = [
    (device_config_table, "Device Configuration"),
    (dq_rules_table, "Data Quality Rules"),
    (processing_config_table, "Processing Configuration"),
    (env_config_table, "Environment Configuration")
]

for table_name, description in tables:
    try:
        count = spark.read.table(table_name).count()
        print(f"{description}: {count} records")
    except Exception as e:
        print(f"Error reading {description}: {str(e)}")

# Show sample from unified view
print(f"\nSample from unified configuration view:")
spark.sql(f"SELECT * FROM {unified_config_view} LIMIT 10").show(truncate=False)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Grant Permissions

# COMMAND ----------

# Grant appropriate permissions on configuration tables
try:
    # Grant read access to data engineers
    for table_name, _ in tables:
        spark.sql(f"GRANT SELECT ON TABLE {table_name} TO `iot-data-engineers`")
    
    # Grant read access to analysts
    for table_name, _ in tables:
        spark.sql(f"GRANT SELECT ON TABLE {table_name} TO `iot-analysts`")
    
    # Grant access to unified view
    spark.sql(f"GRANT SELECT ON VIEW {unified_config_view} TO `iot-data-engineers`")
    spark.sql(f"GRANT SELECT ON VIEW {unified_config_view} TO `iot-analysts`")
    
    print("Permissions granted successfully")
    
except Exception as e:
    print(f"Note: Could not grant permissions (this is normal in dev environment): {str(e)}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Configuration Table Documentation

# COMMAND ----------

# Add table comments for documentation
table_comments = [
    (device_config_table, "Configuration and metadata for IoT devices including thresholds and operational parameters"),
    (dq_rules_table, "Data quality validation rules with severity levels and activation status"),
    (processing_config_table, "Processing pipeline configuration parameters for various components"),
    (env_config_table, "Environment-specific configuration settings for clusters, storage, and jobs"),
    (unified_config_view, "Unified view of all configuration tables for simplified access")
]

for table_name, comment in table_comments:
    try:
        spark.sql(f"ALTER TABLE {table_name} SET TBLPROPERTIES ('comment' = '{comment}')")
        print(f"Added comment to {table_name}")
    except Exception as e:
        print(f"Could not add comment to {table_name}: {str(e)}")

print("Configuration tables setup completed successfully!")

# COMMAND ----------

# Return success status for downstream tasks
dbutils.notebook.exit("SUCCESS") 