FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
RUN apt-get update
RUN apt-get install git -y
RUN apt-get update
RUN apt-get install wget -y
RUN wget "https://dlcdn.apache.org/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz"
RUN tar -xzvf spark-3.2.0-bin-hadoop3.2.tgz
RUN rm spark-3.2.0-bin-hadoop3.2.tgz
RUN apt-get install -y python3-pip python3-dev
RUN apt-get update
RUN pip3 install --upgrade pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip install pyspark
