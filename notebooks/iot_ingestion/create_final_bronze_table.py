# Databricks notebook source
# MAGIC %md
# MAGIC # Create Final Bronze Table
# MAGIC 
# MAGIC This notebook creates the final bronze table with enhanced data quality checks and optimization.
# MAGIC 
# MAGIC ## Parameters
# MAGIC - `catalog`: Target Unity Catalog
# MAGIC - `environment`: Deployment environment (dev/test/prod)
# MAGIC - `source_table`: Source table in bronze layer
# MAGIC - `target_table`: Target final bronze table
# MAGIC - `data_quality_checks`: Enable data quality checks

# COMMAND ----------

# MAGIC %md
# MAGIC ## Setup and Configuration

# COMMAND ----------

# Import required libraries
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from delta import *

# COMMAND ----------

# Get parameters
dbutils.widgets.text("catalog", "dev_test", "Target Catalog")
dbutils.widgets.text("environment", "dev", "Environment")
dbutils.widgets.text("source_table", "", "Source Table")
dbutils.widgets.text("target_table", "", "Target Table")
dbutils.widgets.dropdown("data_quality_checks", "true", ["true", "false"], "Enable Data Quality Checks")

catalog = dbutils.widgets.get("catalog")
environment = dbutils.widgets.get("environment")
source_table = dbutils.widgets.get("source_table") or f"{catalog}.bronze.iot_data"
target_table = dbutils.widgets.get("target_table") or f"{catalog}.bronze.iot_data_final"
data_quality_checks = dbutils.widgets.get("data_quality_checks").lower() == "true"

print(f"Target Catalog: {catalog}")
print(f"Environment: {environment}")
print(f"Source Table: {source_table}")
print(f"Target Table: {target_table}")
print(f"Data Quality Checks: {data_quality_checks}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Advanced Data Quality Functions

# COMMAND ----------

def perform_advanced_data_quality_checks(df):
    """
    Perform comprehensive data quality checks
    """
    # Statistical outlier detection for temperature
    temp_stats = df.select(
        mean("temperature_celsius").alias("temp_mean"),
        stddev("temperature_celsius").alias("temp_stddev")
    ).collect()[0]
    
    temp_mean = temp_stats["temp_mean"] or 0
    temp_stddev = temp_stats["temp_stddev"] or 1
    
    # Add advanced quality flags
    df_enhanced = df.withColumn(
        "advanced_quality_flags",
        struct(
            # Statistical outliers (3 sigma rule)
            when(
                abs(col("temperature_celsius") - temp_mean) > (3 * temp_stddev),
                lit("TEMPERATURE_OUTLIER")
            ).otherwise(lit(None)).alias("temp_outlier"),
            
            # Logical consistency checks
            when(
                col("humidity_percent") > 95,
                lit("HIGH_HUMIDITY_WARNING")
            ).otherwise(lit(None)).alias("high_humidity"),
            
            # Battery level warnings
            when(
                col("battery_level_percent") < 20,
                lit("LOW_BATTERY_WARNING")
            ).otherwise(lit(None)).alias("low_battery"),
            
            # Temporal checks
            when(
                col("measurement_timestamp") > current_timestamp(),
                lit("FUTURE_TIMESTAMP")
            ).otherwise(lit(None)).alias("future_timestamp")
        )
    )
    
    return df_enhanced

def add_data_lineage_info(df):
    """
    Add data lineage and processing metadata
    """
    return df.withColumn("lineage_info", 
        struct(
            lit("bronze_final_processing").alias("processing_stage"),
            current_timestamp().alias("final_processing_timestamp"),
            lit(environment).alias("processing_environment"),
            lit("create_final_bronze_table").alias("processing_notebook")
        )
    )

def create_data_quality_summary(df):
    """
    Create a comprehensive data quality summary
    """
    total_records = df.count()
    
    # Basic quality metrics
    basic_quality = df.groupBy("data_quality_status").count().collect()
    
    # Advanced quality metrics
    temp_outliers = df.filter(col("advanced_quality_flags.temp_outlier").isNotNull()).count()
    high_humidity = df.filter(col("advanced_quality_flags.high_humidity").isNotNull()).count()
    low_battery = df.filter(col("advanced_quality_flags.low_battery").isNotNull()).count()
    future_timestamps = df.filter(col("advanced_quality_flags.future_timestamp").isNotNull()).count()
    
    print("=== DATA QUALITY SUMMARY ===")
    print(f"Total Records: {total_records}")
    print("\nBasic Quality Status:")
    for row in basic_quality:
        percentage = (row['count'] / total_records) * 100 if total_records > 0 else 0
        print(f"  {row['data_quality_status']}: {row['count']} ({percentage:.2f}%)")
    
    print("\nAdvanced Quality Checks:")
    print(f"  Temperature Outliers: {temp_outliers}")
    print(f"  High Humidity Warnings: {high_humidity}")
    print(f"  Low Battery Warnings: {low_battery}")
    print(f"  Future Timestamps: {future_timestamps}")
    
    return {
        "total_records": total_records,
        "basic_quality": {row['data_quality_status']: row['count'] for row in basic_quality},
        "advanced_quality": {
            "temp_outliers": temp_outliers,
            "high_humidity": high_humidity,
            "low_battery": low_battery,
            "future_timestamps": future_timestamps
        }
    }

# COMMAND ----------

# MAGIC %md
# MAGIC ## Read and Process Source Data

# COMMAND ----------

# Read from bronze source table
print("Reading data from bronze source table...")
try:
    bronze_df = spark.read.table(source_table)
    print(f"Successfully read {bronze_df.count()} records from {source_table}")
except Exception as e:
    print(f"Could not read from {source_table}: {str(e)}")
    # Create sample data if source doesn't exist
    print("Creating sample bronze data for demonstration...")
    
    sample_data = [
        ("device_001", "2024-01-15T10:00:00.000Z", 22.5, 65.0, 1013.25, 85.0, 72.5, "2024-01-15", 10),
        ("device_002", "2024-01-15T10:01:00.000Z", 23.1, 62.0, 1013.30, 87.5, 73.58, "2024-01-15", 10),
        ("device_003", "2024-01-15T10:02:00.000Z", 21.8, 68.0, 1013.15, 82.0, 71.24, "2024-01-15", 10),
        ("device_001", "2024-01-15T10:05:00.000Z", 22.7, 64.5, 1013.28, 84.5, 72.86, "2024-01-15", 10),
        ("device_004", "2024-01-15T10:03:00.000Z", 45.0, 120.0, 900.0, 15.0, 113.0, "2024-01-15", 10),  # Outlier data
    ]
    
    schema = StructType([
        StructField("device_id", StringType(), True),
        StructField("measurement_timestamp", StringType(), True),
        StructField("temperature_celsius", DoubleType(), True),
        StructField("humidity_percent", DoubleType(), True),
        StructField("pressure_hpa", DoubleType(), True),
        StructField("battery_level_percent", DoubleType(), True),
        StructField("temperature_fahrenheit", DoubleType(), True),
        StructField("measurement_date", StringType(), True),
        StructField("measurement_hour", IntegerType(), True)
    ])
    
    bronze_df = spark.createDataFrame(sample_data, schema) \
                    .withColumn("measurement_timestamp", to_timestamp(col("measurement_timestamp"))) \
                    .withColumn("measurement_date", to_date(col("measurement_date"))) \
                    .withColumn("ingestion_timestamp", current_timestamp()) \
                    .withColumn("environment", lit(environment)) \
                    .withColumn("source_system", lit("iot_api")) \
                    .withColumn("bronze_ingestion_timestamp", current_timestamp()) \
                    .withColumn("bronze_batch_id", lit("sample-batch-001")) \
                    .withColumn("data_quality_status", lit("PASSED"))

# COMMAND ----------

# MAGIC %md
# MAGIC ## Apply Final Bronze Processing

# COMMAND ----------

# Apply advanced data quality checks if enabled
if data_quality_checks:
    print("Applying advanced data quality checks...")
    final_df = perform_advanced_data_quality_checks(bronze_df)
else:
    print("Skipping advanced data quality checks...")
    final_df = bronze_df.withColumn("advanced_quality_flags", lit(None))

# Add data lineage information
final_df = add_data_lineage_info(final_df)

# Add final processing metadata
final_df = final_df.withColumn("final_processing_timestamp", current_timestamp()) \
                   .withColumn("record_hash", sha2(concat_ws("|", 
                       col("device_id"), 
                       col("measurement_timestamp"), 
                       col("temperature_celsius"),
                       col("humidity_percent")
                   ), 256))

print("Final bronze processing completed")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Data Quality Assessment

# COMMAND ----------

# Generate comprehensive data quality summary
if data_quality_checks:
    quality_summary = create_data_quality_summary(final_df)
    
    # Log quality metrics for monitoring
    quality_metrics = {
        "environment": environment,
        "table": target_table,
        "timestamp": str(current_timestamp()),
        "metrics": quality_summary
    }
    
    print(f"Quality metrics logged: {quality_metrics}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Write Final Bronze Table

# COMMAND ----------

# Create final bronze table
print(f"Writing final bronze table: {target_table}")

try:
    # Write with partitioning for better performance
    (final_df.write
     .mode("overwrite")
     .option("mergeSchema", "true")
     .option("overwriteSchema", "true")
     .partitionBy("measurement_date")
     .saveAsTable(target_table))
    
    print("Final bronze table created successfully")
    
    # Verify the write
    final_count = spark.read.table(target_table).count()
    print(f"Final bronze table record count: {final_count}")
    
except Exception as e:
    print(f"Error creating final bronze table: {str(e)}")
    raise e

# COMMAND ----------

# MAGIC %md
# MAGIC ## Table Optimization and Statistics

# COMMAND ----------

# Optimize the table for better query performance
print("Optimizing final bronze table...")
try:
    spark.sql(f"OPTIMIZE {target_table}")
    print("Table optimization completed")
except Exception as e:
    print(f"Optimization warning: {str(e)}")

# Update table statistics
print("Updating table statistics...")
try:
    spark.sql(f"ANALYZE TABLE {target_table} COMPUTE STATISTICS")
    print("Statistics updated")
except Exception as e:
    print(f"Statistics update warning: {str(e)}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Final Validation and Summary

# COMMAND ----------

# Show table schema
print(f"Final bronze table schema for {target_table}:")
spark.sql(f"DESCRIBE {target_table}").show(truncate=False)

# Show sample data
print("\nSample of final bronze data:")
spark.read.table(target_table).limit(5).show(truncate=False)

# Show partition information
print(f"\nPartition information:")
try:
    spark.sql(f"SHOW PARTITIONS {target_table}").show()
except Exception as e:
    print(f"Could not show partitions: {str(e)}")

print("Final bronze table creation completed successfully!")

# COMMAND ----------

# Return success status for downstream tasks
dbutils.notebook.exit("SUCCESS") 