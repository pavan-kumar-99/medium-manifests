"""
Unit tests for IoT data transformations

This module contains unit tests for the data transformation logic
used in the IoT ingestion pipeline.
"""

import unittest
from unittest.mock import Mock, patch
import pandas as pd
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, TimestampType, IntegerType
from pyspark.sql.functions import col, current_timestamp, lit
import pytest


class TestIoTDataTransformations(unittest.TestCase):
    """Test cases for IoT data transformation functions"""
    
    @classmethod
    def setUpClass(cls):
        """Set up Spark session for testing"""
        cls.spark = SparkSession.builder \
            .appName("IoT_Data_Tests") \
            .master("local[2]") \
            .config("spark.sql.shuffle.partitions", "2") \
            .getOrCreate()
        cls.spark.sparkContext.setLogLevel("WARN")
    
    @classmethod
    def tearDownClass(cls):
        """Clean up Spark session"""
        cls.spark.stop()
    
    def setUp(self):
        """Set up test data"""
        # Sample IoT data
        self.sample_data = [
            ("device_001", "2024-01-15T10:00:00.000Z", 22.5, 65.0, 1013.25, 85.0),
            ("device_002", "2024-01-15T10:01:00.000Z", 23.1, 62.0, 1013.30, 87.5),
            ("device_003", "2024-01-15T10:02:00.000Z", 21.8, 68.0, 1013.15, 82.0),
            ("device_001", "2024-01-15T10:05:00.000Z", 22.7, 64.5, 1013.28, 84.5),
        ]
        
        self.schema = StructType([
            StructField("device_id", StringType(), True),
            StructField("timestamp", StringType(), True),
            StructField("temperature", DoubleType(), True),
            StructField("humidity", DoubleType(), True),
            StructField("pressure", DoubleType(), True),
            StructField("battery_level", DoubleType(), True)
        ])
        
        self.test_df = self.spark.createDataFrame(self.sample_data, self.schema)
    
    def test_temperature_conversion(self):
        """Test temperature conversion from Celsius to Fahrenheit"""
        # Apply temperature conversion
        result_df = self.test_df.withColumn(
            "temperature_fahrenheit",
            (col("temperature") * 9 / 5) + 32
        )
        
        # Check conversion for first record (22.5°C should be 72.5°F)
        first_row = result_df.collect()[0]
        expected_fahrenheit = (22.5 * 9 / 5) + 32
        
        self.assertAlmostEqual(
            first_row["temperature_fahrenheit"], 
            expected_fahrenheit, 
            places=2
        )
    
    def test_data_quality_validation(self):
        """Test data quality validation logic"""
        # Add data quality flags
        validated_df = self.test_df.withColumn(
            "is_valid_temperature",
            (col("temperature") >= -50) & (col("temperature") <= 100)
        ).withColumn(
            "is_valid_humidity",
            (col("humidity") >= 0) & (col("humidity") <= 100)
        ).withColumn(
            "is_valid_pressure",
            (col("pressure") >= 800) & (col("pressure") <= 1200)
        )
        
        # All records should pass validation
        invalid_temp_count = validated_df.filter(col("is_valid_temperature") == False).count()
        invalid_humidity_count = validated_df.filter(col("is_valid_humidity") == False).count()
        invalid_pressure_count = validated_df.filter(col("is_valid_pressure") == False).count()
        
        self.assertEqual(invalid_temp_count, 0)
        self.assertEqual(invalid_humidity_count, 0)
        self.assertEqual(invalid_pressure_count, 0)
    
    def test_invalid_data_detection(self):
        """Test detection of invalid data"""
        # Create test data with invalid values
        invalid_data = [
            ("device_004", "2024-01-15T10:00:00.000Z", 150.0, 65.0, 1013.25, 85.0),  # Invalid temp
            ("device_005", "2024-01-15T10:01:00.000Z", 23.1, 150.0, 1013.30, 87.5),  # Invalid humidity
            ("device_006", "2024-01-15T10:02:00.000Z", 21.8, 68.0, 500.0, 82.0),     # Invalid pressure
        ]
        
        invalid_df = self.spark.createDataFrame(invalid_data, self.schema)
        
        # Apply validation
        validated_df = invalid_df.withColumn(
            "is_valid_temperature",
            (col("temperature") >= -50) & (col("temperature") <= 100)
        ).withColumn(
            "is_valid_humidity",
            (col("humidity") >= 0) & (col("humidity") <= 100)
        ).withColumn(
            "is_valid_pressure",
            (col("pressure") >= 800) & (col("pressure") <= 1200)
        )
        
        # Should detect invalid records
        invalid_temp_count = validated_df.filter(col("is_valid_temperature") == False).count()
        invalid_humidity_count = validated_df.filter(col("is_valid_humidity") == False).count()
        invalid_pressure_count = validated_df.filter(col("is_valid_pressure") == False).count()
        
        self.assertEqual(invalid_temp_count, 1)
        self.assertEqual(invalid_humidity_count, 1)
        self.assertEqual(invalid_pressure_count, 1)
    
    def test_null_handling(self):
        """Test handling of null values"""
        # Create test data with null values
        null_data = [
            ("device_007", "2024-01-15T10:00:00.000Z", None, 65.0, 1013.25, 85.0),
            (None, "2024-01-15T10:01:00.000Z", 23.1, 62.0, 1013.30, 87.5),
            ("device_009", None, 21.8, 68.0, 1013.15, 82.0),
        ]
        
        null_df = self.spark.createDataFrame(null_data, self.schema)
        
        # Check for null values
        null_device_count = null_df.filter(col("device_id").isNull()).count()
        null_temp_count = null_df.filter(col("temperature").isNull()).count()
        null_timestamp_count = null_df.filter(col("timestamp").isNull()).count()
        
        self.assertEqual(null_device_count, 1)
        self.assertEqual(null_temp_count, 1)
        self.assertEqual(null_timestamp_count, 1)
    
    def test_device_aggregation(self):
        """Test device-level aggregation"""
        # Aggregate by device
        device_stats = self.test_df.groupBy("device_id").agg(
            {"temperature": "avg", "humidity": "avg", "pressure": "avg", "battery_level": "avg"}
        ).collect()
        
        # Should have stats for 2 unique devices (device_001 appears twice)
        device_001_stats = [row for row in device_stats if row["device_id"] == "device_001"][0]
        
        # device_001 has temperatures 22.5 and 22.7, so average should be 22.6
        expected_avg_temp = (22.5 + 22.7) / 2
        self.assertAlmostEqual(
            device_001_stats["avg(temperature)"], 
            expected_avg_temp, 
            places=2
        )
    
    def test_data_enrichment(self):
        """Test data enrichment with metadata"""
        enriched_df = self.test_df.withColumn("ingestion_timestamp", current_timestamp()) \
                                  .withColumn("environment", lit("test")) \
                                  .withColumn("source_system", lit("iot_api"))
        
        # Check that enrichment columns are added
        columns = enriched_df.columns
        self.assertIn("ingestion_timestamp", columns)
        self.assertIn("environment", columns)
        self.assertIn("source_system", columns)
        
        # Check values
        first_row = enriched_df.collect()[0]
        self.assertEqual(first_row["environment"], "test")
        self.assertEqual(first_row["source_system"], "iot_api")


class TestDataQualityRules(unittest.TestCase):
    """Test cases for data quality rules"""
    
    def test_temperature_range_rule(self):
        """Test temperature range validation rule"""
        # Valid range: -50 to 100 degrees Celsius
        valid_temps = [0, 25, 50, -10, 99]
        invalid_temps = [-60, 150, 200]
        
        for temp in valid_temps:
            self.assertTrue(-50 <= temp <= 100, f"Temperature {temp} should be valid")
        
        for temp in invalid_temps:
            self.assertFalse(-50 <= temp <= 100, f"Temperature {temp} should be invalid")
    
    def test_humidity_range_rule(self):
        """Test humidity range validation rule"""
        # Valid range: 0 to 100 percent
        valid_humidity = [0, 25, 50, 75, 100]
        invalid_humidity = [-10, 150]
        
        for humidity in valid_humidity:
            self.assertTrue(0 <= humidity <= 100, f"Humidity {humidity} should be valid")
        
        for humidity in invalid_humidity:
            self.assertFalse(0 <= humidity <= 100, f"Humidity {humidity} should be invalid")
    
    def test_pressure_range_rule(self):
        """Test pressure range validation rule"""
        # Valid range: 800 to 1200 hPa
        valid_pressure = [850, 1000, 1150]
        invalid_pressure = [700, 1300]
        
        for pressure in valid_pressure:
            self.assertTrue(800 <= pressure <= 1200, f"Pressure {pressure} should be valid")
        
        for pressure in invalid_pressure:
            self.assertFalse(800 <= pressure <= 1200, f"Pressure {pressure} should be invalid")


class TestIntegrationScenarios(unittest.TestCase):
    """Integration test scenarios"""
    
    @classmethod
    def setUpClass(cls):
        """Set up Spark session for integration tests"""
        cls.spark = SparkSession.builder \
            .appName("IoT_Integration_Tests") \
            .master("local[2]") \
            .getOrCreate()
    
    @classmethod
    def tearDownClass(cls):
        """Clean up Spark session"""
        cls.spark.stop()
    
    def test_end_to_end_processing(self):
        """Test end-to-end data processing pipeline"""
        # Sample input data
        input_data = [
            ("device_001", "2024-01-15T10:00:00", 22.5, 65.0, 1013.25, 85.0),
            ("device_002", "2024-01-15T10:01:00", 23.1, 62.0, 1013.30, 87.5),
        ]
        
        schema = StructType([
            StructField("device_id", StringType(), True),
            StructField("timestamp", StringType(), True),
            StructField("temperature", DoubleType(), True),
            StructField("humidity", DoubleType(), True),
            StructField("pressure", DoubleType(), True),
            StructField("battery_level", DoubleType(), True)
        ])
        
        df = self.spark.createDataFrame(input_data, schema)
        
        # Apply transformations (simulating the pipeline)
        processed_df = df.withColumn("timestamp", col("timestamp").cast("timestamp")) \
                         .withColumn("temperature_fahrenheit", (col("temperature") * 9 / 5) + 32) \
                         .withColumn("is_valid", 
                                   (col("temperature") >= -50) & (col("temperature") <= 100) &
                                   (col("humidity") >= 0) & (col("humidity") <= 100) &
                                   (col("pressure") >= 800) & (col("pressure") <= 1200)) \
                         .withColumn("processing_timestamp", current_timestamp())
        
        # Verify results
        results = processed_df.collect()
        
        self.assertEqual(len(results), 2)
        
        # Check first record
        first_record = results[0]
        self.assertEqual(first_record["device_id"], "device_001")
        self.assertAlmostEqual(first_record["temperature_fahrenheit"], 72.5, places=1)
        self.assertTrue(first_record["is_valid"])


if __name__ == "__main__":
    # Run tests
    unittest.main(verbosity=2) 