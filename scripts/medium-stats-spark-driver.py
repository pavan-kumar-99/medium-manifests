import boto3
import botocore
from pyspark import SparkConf
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.window import Window
from pyspark.sql.types import *

# Define a function to download files from S3
def download_from_s3(bucket_name, key, local_path):
    """
    Download a file from Amazon S3 to the local file system.
    
    Args:
    - bucket_name: The name of the S3 bucket.
    - key: The key (path) of the file in the S3 bucket.
    - local_path: The local path where the file will be downloaded.
    """
    s3 = boto3.client('s3')
    try:
        s3.download_file(bucket_name, key, local_path)
        print(f"File downloaded successfully from S3: s3://{bucket_name}/{key} to {local_path}")
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == "404":
            print(f"The object does not exist: s3://{bucket_name}/{key}")
        else:
            raise

# Download files from S3
download_from_s3("your-bucket-name", "path/to/file.json", "local/file.json")

# Set up Spark session and configuration
conf = SparkConf()
spark = SparkSession.builder \
    .appName("Medium Stats Pavan") \
    .config(conf=conf) \
    .getOrCreate()

# Define schema for the data
schema = StructType([
    StructField("dayStartsAt", LongType(), True),
    StructField("id", IntegerType(), True),
    StructField("Date", LongType(), True),
    StructField("readersThatClappedCount", LongType(), True),
    StructField("readersThatReadCount", LongType(), True),
    StructField("readersThatRepliedCount", LongType(), True),
    StructField("readersThatViewedCount", LongType(), True),
    StructField("article_id", LongType(), True)
])

# Read JSON files into DataFrames
df_all = spark.read.option("multiLine", "true").option("mode", "PERMISSIVE").schema(schema).json("local")
df = spark.read.option("multiLine", "true").option("mode", "PERMISSIVE").schema(schema).json("local")
df_posts = spark.read.option("multiLine", "true").option("mode", "PERMISSIVE").json("local/posts_info.json")

# Data transformations
df = df.dropDuplicates()  # Drop duplicate rows
df = df.withColumn('article_id', lit('ef99f7a4e417'))  # Set article_id
df = df.withColumn('Date', to_date(from_unixtime(floor(col('dayStartsAt') / 1000), 'yyyy-MM-dd HH:mm:ss')))  # Convert timestamp to date
columns_to_drop = ['__typename', 'membershipType', 'dayStartsAt', 'readersThatInitiallyFollowedAuthorFromThisPostCount', 'readersThatHighlightedCount']
df = df.drop(*columns_to_drop)  # Drop unnecessary columns
window = Window.orderBy(col('Date'))
df = df.withColumn('id', row_number().over(window))  # Add row number

# Join operation
df_join = df.join(df_posts, df['article_id'] == df_posts['article_id'], 'inner').drop(df.article_id)

# Count rows in df_all DataFrame
total_rows = df_all.count()

# Print total rows count
print("Total rows in df_all DataFrame:", total_rows)
