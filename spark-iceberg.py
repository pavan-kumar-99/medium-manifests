from pyspark import SparkConf
from pyspark.sql import SparkSession

# Spark Session Configuration
conf = (
    SparkConf()
    .set("spark.mongodb.write.connection.uri", "mongodb+srv://test:test@spark.cvq7lmq.mongodb.net/test.test")
    .set("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
    .set("spark.sql.catalog.demo", "org.apache.iceberg.spark.SparkCatalog")
    .set("spark.sql.catalog.demo.type", "hadoop")
    .set("spark.sql.catalog.demo.warehouse", "s3a://openlake/warehouse/")
    .set("spark.sql.catalog.demo.s3.endpoint", "http://10.0.0.185:9000/")
    .set("spark.sql.defaultCatalog", "demo")
    .set("spark.executor.heartbeatInterval", "300000")
    .set("spark.network.timeout", "400000")
    .set('spark.hadoop.fs.s3a.access.key', "xx")
    .set('spark.hadoop.fs.s3a.secret.key', "xx")
    .set("spark.hadoop.fs.s3a.endpoint", "http://10.0.0.185:9000/")
)


spark = SparkSession.builder \
    .appName("MongoDB Integration") \
    .config(conf=conf) \
    .getOrCreate()

# Load the Data into CSV file
df = spark.read.csv("/Users/pavakuma/Downloads/h1b_kaggle.csv", header=True, inferSchema=True)

# Print the total number of records to be written
print("Records to write",df.count())

# Created a table in Apache iceberg
df.writeTo("h1b.info").create()
