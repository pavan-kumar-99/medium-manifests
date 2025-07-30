# Databricks notebook source
# MAGIC %md
# MAGIC # IoT API Ingestion Framework
# MAGIC 
# MAGIC This notebook handles data ingestion from IoT API endpoints.
# MAGIC 
# MAGIC ## Parameters
# MAGIC - `catalog`: Target Unity Catalog
# MAGIC - `environment`: Deployment environment (dev/test/prod)
# MAGIC - `checkpoint_location`: Checkpoint location for streaming

# COMMAND ----------

# MAGIC %md
# MAGIC ## Setup and Configuration

# COMMAND ----------

# Import required libraries
import requests
import json
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from delta import *

# COMMAND ----------

# Get parameters
dbutils.widgets.text("catalog", "dev_test", "Target Catalog")
dbutils.widgets.text("environment", "dev", "Environment")
dbutils.widgets.text("checkpoint_location", "/tmp/checkpoints/api_ingestion", "Checkpoint Location")

catalog = dbutils.widgets.get("catalog")
environment = dbutils.widgets.get("environment")
checkpoint_location = dbutils.widgets.get("checkpoint_location")

print(f"Target Catalog: {catalog}")
print(f"Environment: {environment}")
print(f"Checkpoint Location: {checkpoint_location}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## API Configuration

# COMMAND ----------

# Configure API endpoints and authentication
# Note: In production, use Databricks secrets for API keys
api_config = {
    "base_url": "https://api.iot-platform.com/v1",
    "endpoints": {
        "devices": "/devices",
        "telemetry": "/telemetry",
        "events": "/events"
    },
    "headers": {
        "Content-Type": "application/json",
        # "Authorization": f"Bearer {dbutils.secrets.get('iot-secrets', 'api-token')}"
        "Authorization": "Bearer your-api-token-here"  # Replace with secrets in production
    }
}

# COMMAND ----------

# MAGIC %md
# MAGIC ## Data Ingestion Functions

# COMMAND ----------

def fetch_api_data(endpoint, params=None):
    """
    Fetch data from IoT API endpoint
    """
    url = api_config["base_url"] + api_config["endpoints"][endpoint]
    
    try:
        response = requests.get(
            url, 
            headers=api_config["headers"],
            params=params,
            timeout=30
        )
        response.raise_for_status()
        
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from {endpoint}: {str(e)}")
        return None

def create_dataframe_from_api(data, schema=None):
    """
    Convert API response to Spark DataFrame
    """
    if not data:
        return spark.createDataFrame([], StructType([]))
    
    # Convert to DataFrame
    if schema:
        df = spark.createDataFrame(data, schema)
    else:
        df = spark.read.json(spark.sparkContext.parallelize([json.dumps(data)]))
    
    # Add metadata columns
    df = df.withColumn("ingestion_timestamp", current_timestamp()) \
           .withColumn("environment", lit(environment)) \
           .withColumn("source_system", lit("iot_api"))
    
    return df

# COMMAND ----------

# MAGIC %md
# MAGIC ## Data Schema Definitions

# COMMAND ----------

# Define schemas for different data types
device_schema = StructType([
    StructField("device_id", StringType(), True),
    StructField("device_name", StringType(), True),
    StructField("device_type", StringType(), True),
    StructField("location", StringType(), True),
    StructField("status", StringType(), True),
    StructField("last_seen", TimestampType(), True)
])

telemetry_schema = StructType([
    StructField("device_id", StringType(), True),
    StructField("timestamp", TimestampType(), True),
    StructField("temperature", DoubleType(), True),
    StructField("humidity", DoubleType(), True),
    StructField("pressure", DoubleType(), True),
    StructField("battery_level", DoubleType(), True)
])

# COMMAND ----------

# MAGIC %md
# MAGIC ## Main Ingestion Process

# COMMAND ----------

# Create database/schema if not exists
spark.sql(f"CREATE SCHEMA IF NOT EXISTS {catalog}.raw")

# Fetch device data
print("Fetching device data...")
device_data = fetch_api_data("devices")
if device_data:
    device_df = create_dataframe_from_api(device_data.get("devices", []), device_schema)
    print(f"Retrieved {device_df.count()} device records")
    
    # Write to raw layer
    (device_df.write
     .mode("overwrite")
     .option("mergeSchema", "true")
     .saveAsTable(f"{catalog}.raw.devices"))
    
    print("Device data written to raw layer")

# COMMAND ----------

# Fetch telemetry data
print("Fetching telemetry data...")
telemetry_data = fetch_api_data("telemetry", {"limit": 1000})
if telemetry_data:
    telemetry_df = create_dataframe_from_api(telemetry_data.get("readings", []), telemetry_schema)
    print(f"Retrieved {telemetry_df.count()} telemetry records")
    
    # Write to raw layer
    (telemetry_df.write
     .mode("append")
     .option("mergeSchema", "true")
     .saveAsTable(f"{catalog}.raw.telemetry"))
    
    print("Telemetry data written to raw layer")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Data Quality Checks

# COMMAND ----------

# Perform basic data quality checks
print("Performing data quality checks...")

# Check for null device IDs
null_device_count = spark.sql(f"""
    SELECT COUNT(*) as null_count 
    FROM {catalog}.raw.telemetry 
    WHERE device_id IS NULL
""").collect()[0]["null_count"]

if null_device_count > 0:
    print(f"WARNING: Found {null_device_count} records with null device_id")

# Check for duplicate device IDs
duplicate_device_count = spark.sql(f"""
    SELECT COUNT(*) as duplicate_count
    FROM (
        SELECT device_id, COUNT(*) as cnt
        FROM {catalog}.raw.devices
        GROUP BY device_id
        HAVING COUNT(*) > 1
    )
""").collect()[0]["duplicate_count"]

if duplicate_device_count > 0:
    print(f"WARNING: Found {duplicate_device_count} duplicate device records")

print("Data ingestion completed successfully!")

# COMMAND ----------

# Return success status for downstream tasks
dbutils.notebook.exit("SUCCESS") 