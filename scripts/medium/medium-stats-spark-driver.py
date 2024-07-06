import argparse
import boto3
import os
import botocore
from pyspark import SparkConf
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *


## Define a function to download files from S3
def download_from_s3(bucket_name, key, local_path):
    """
    Download a file from Amazon S3 to the local file system.

    Args:
    - bucket_name: The name of the S3 bucket.
    - key: The key (path) of the file in the S3 bucket.
    - local_path: The local path where the file will be downloaded.
    """
    s3 = boto3.resource("s3",endpoint_url="http://minio-server.minio:9000")
    try:
        bucket = s3.Bucket(bucket_name)
        for obj in bucket.objects.filter(Prefix=key):
            target = (
                obj.key
                if local_path is None
                else os.path.join(local_path, os.path.relpath(obj.key, key))
            )
            if not os.path.exists(os.path.dirname(target)):
                os.makedirs(os.path.dirname(target))
            if obj.key[-1] == "/":
                continue
            bucket.download_file(obj.key, target)
            print("Object Downloaded", obj.key)
    except botocore.exceptions.ClientError as e:
        if e.response["Error"]["Code"] == "404":
            print(f"The object does not exist: s3://{bucket_name}/{key}")
        else:
            raise


def process_data(bucket_name, bucket_prefix, local_path):
    """
    Process data from JSON files and return the joined DataFrame.

    Args:
    - bucket_name: Name of the S3 bucket.
    - bucket_prefix: Key (path) of the file in the S3 bucket.
    - local_path: Local path where the file will be downloaded.

    Returns:
    - Joined DataFrame.
    - Spark Session.
    """
    catalog_name = "medium_stats"
    iceberg_bucket_name = bucket_name
    iceberg_bucket_prefix = bucket_prefix
    warehouse_path = f"s3a://{iceberg_bucket_name}/{iceberg_bucket_prefix}"
    print("Warehouse path is",warehouse_path)
    mongodb_uri = os.getenv("MONGO_URI")
    access_key = os.getenv("AWS_ACCESS_KEY_ID")
    secret_key = os.getenv("AWS_SECRET_ACCESS_KEY")
    
    if not mongodb_uri:
        raise ValueError("MONGO_URI environment variable is not set")

    # Initialize Spark session
    spark = (
        SparkSession.builder.appName("Medium Stats Pavan")
        .config(
            "spark.jars",
            "/opt/spark/jars/mongo-spark-connector_2.12-10.3.0.jar,/opt/spark/jars/iceberg-spark-runtime-3.3_2.12-1.5.2.jar,/opt/spark/jars/iceberg-aws-bundle-1.4.3.jar,/opt/spark/jars/mongodb-driver-sync-4.8.1.jar,/opt/spark/jars/bson-4.8.1.jar,/opt/spark/jars/mongodb-driver-core-4.8.1.jar,/opt/spark/jars/bson-record-codec-4.8.1.jar",
        )
        .config(
            f"spark.sql.catalog.{catalog_name}", "org.apache.iceberg.spark.SparkCatalog"
        )
        .config(f"spark.sql.catalog.{catalog_name}.warehouse", f"{warehouse_path}")
        .config(
            f"spark.sql.catalog.{catalog_name}.type",
            "hadoop",
        )
        .config(f"spark.sql.defaultCatalog", f"{catalog_name}")
        .config(
            "spark.sql.extensions",
            "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions",
        )
        .config(
            "spark.mongodb.write.connection.uri",
            f"{mongodb_uri}",
        )
        .config(
            "spark.hadoop.fs.s3a.endpoint",
            "http://10.100.44.242:9000/",
        )
        .config(
            "spark.sql.catalogImplementation",
            "in-memory",
        )
        .config(
            "spark.hadoop.fs.s3a.access.key",
            f"{access_key}",
        )
        .config(
            "spark.hadoop.fs.s3a.secret.key",
            f"{secret_key}",
        )
        .getOrCreate()
    )

    spark.sparkContext.setLogLevel("OFF")

    statsSchema = StructType(
        [
            StructField("dayStartsAt", LongType(), True),
            StructField("Date", LongType(), True),
            StructField("readersThatClappedCount", LongType(), True),
            StructField("readersThatReadCount", LongType(), True),
            StructField("readersThatRepliedCount", LongType(), True),
            StructField("readersThatViewedCount", LongType(), True),
            StructField("article_id", StringType(), True),
        ]
    )

    articlesSchema = StructType(
        [
            StructField("article_id", StringType(), True),
            StructField("title", StringType(), True),
            StructField("url", StringType(), True),
        ]
    )

    # Read JSON files into DataFrames
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, "articles.json")
    df = (
        spark.read.option("multiLine", "true")
        .option("mode", "PERMISSIVE")
        .schema(statsSchema)
        .json(local_path)
    )

    df_posts = (
        spark.read.option("multiLine", "true")
        .option("mode", "PERMISSIVE")
        .schema(articlesSchema)
        .json("/opt/articles.json")
    )

    # Data transformations
    df = df.dropDuplicates()  # Drop duplicate rows
    df_posts = df_posts.dropDuplicates()
    df = df.withColumn(
        "Date",
        to_date(from_unixtime(floor(col("dayStartsAt") / 1000), "yyyy-MM-dd")),
    )
    columns_to_drop = [
        "__typename",
        "membershipType",
        "dayStartsAt",
        "readersThatInitiallyFollowedAuthorFromThisPostCount",
        "readersThatHighlightedCount",
    ]
    df = df.drop(*columns_to_drop)

    # Join operation
    df_join = (
        df.join(df_posts, df["article_id"] == df_posts["article_id"], "inner")
        .drop(df.article_id)
        .withColumnRenamed("readersThatViewedCount", "Viewers")
    )

    return df_join, spark


def compute_yearly_statistics(spark, table_name):
    """
    Compute yearly statistics using Apache Spark.

    Args:
    - spark: The SparkSession object.
    - df: The DataFrame containing the data for computation.
    """

    df = spark.sql(
        f"""select title AS Title ,
        Sum(Viewers) AS Total_Viewers,
        FIRST(url) AS URL 
        from {table_name} GROUP BY title ORDER BY Total_Viewers DESC;"""
    )
    df.show(100, truncate=False)
    return df


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Process files from S3 and perform data transformations."
    )
    parser.add_argument("key", type=str, help="Key (path) of the file in the S3 bucket")
    parser.add_argument(
        "ingest_mode",
        type=str,
        choices=["append", "create"],
        help="Ingestion mode: append or create",
    )
    args = parser.parse_args()
    
    catalog_name = "medium_stats"
    db_name = "mediumstats"
    table_name = "articles"
    local_path = "/usr/stats/" + args.key
    bucket_name = "medium-stats"
    iceberg_bucket_name = "iceberg-table"
    iceberg_bucket_prefix = "warehouse/"
    temp_table_name = "mediumstatstemp"

    download_from_s3(bucket_name, args.key, local_path)

    df, spark = process_data(iceberg_bucket_name, iceberg_bucket_prefix, local_path)

    df.cache()

    if args.ingest_mode == "append":
        df.createOrReplaceTempView(f"""{temp_table_name}""")
        print("Merging Data to Iceberg")
        spark.sql(
            f"""
                MERGE INTO {catalog_name}.{db_name}.{table_name} a
                USING {temp_table_name} b
                on a.Date = b.Date
                WHEN NOT MATCHED THEN INSERT *;
                """
        )

        df_yearly = compute_yearly_statistics(spark, temp_table_name)
        print("Writing yearly stats to mongo")
        df_yearly.write.format("mongodb").mode("overwrite").option(
            "database", "medium"
        ).option("collection", "yearlyStats").save()

    elif args.ingest_mode == "create":
        spark.sql(
            f"""
                    CREATE TABLE IF NOT EXISTS {catalog_name}.{db_name}.{table_name} (
                        Date date,
                        readersThatClappedCount long,
                        readersThatReadCount int,
                        readersThatRepliedCount int,
                        Viewers int,
                        article_id string,
                        title string,
                        url string
                        ) using iceberg
                        PARTITIONED BY (year(Date),title);
                    """
        )
        # df.writeTo(f"{catalog_name}.{db_name}.{table_name}").overwritePartitions()
        df.writeTo(f"{catalog_name}.{db_name}.{table_name}")
        print("Data created table", table_name)
        print("Data writing to mongo")
        df.write.format("mongodb").mode("overwrite").option(
            "database", "medium"
        ).option("collection", "allStats").save()
