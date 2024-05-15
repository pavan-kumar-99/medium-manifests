FROM eclipse-temurin:11-jre-focal

# SCALA = 2.12.15
# PY - 3.9.17
# openjdk 17.0.8 2023-07-18 LTS

ARG spark_uid=185

RUN groupadd --system --gid=${spark_uid} spark && \
    useradd --system --uid=${spark_uid} --gid=spark spark

RUN set -ex && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt install -y gnupg2 wget bash tini libc6 libpam-modules krb5-user libnss3 procps net-tools gosu && \
    apt install -y python3 python3-pip && \
    mkdir -p /opt/spark && \
    mkdir /opt/spark/python && \
    mkdir -p /opt/spark/examples && \
    mkdir -p /opt/spark/work-dir && \
    touch /opt/spark/RELEASE && \
    chown -R spark:spark /opt/spark && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/*

# Install Apache Spark
# https://downloads.apache.org/spark/KEYS
ENV SPARK_TGZ_URL=https://archive.apache.org/dist/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz \
    SPARK_TGZ_ASC_URL=https://archive.apache.org/dist/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz.asc \
    GPG_KEY=C56349D886F2B01F8CAE794C653C2301FEA493EE

RUN set -ex; \
    export SPARK_TMP="$(mktemp -d)"; \
    cd $SPARK_TMP; \
    wget -nv -O spark.tgz "$SPARK_TGZ_URL"; \
    wget -nv -O spark.tgz.asc "$SPARK_TGZ_ASC_URL"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver hkps://keys.openpgp.org --recv-key "$GPG_KEY" || \
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys "$GPG_KEY"; \
    gpg --batch --verify spark.tgz.asc spark.tgz; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME" spark.tgz.asc; \
    \
    tar -xf spark.tgz --strip-components=1; \
    chown -R spark:spark .; \
    mv jars /opt/spark/; \
    mv bin /opt/spark/; \
    mv sbin /opt/spark/; \
    mv kubernetes/dockerfiles/spark/decom.sh /opt/; \
    mv examples /opt/spark/; \
    mv kubernetes/tests /opt/spark/; \
    mv data /opt/spark/; \
    mv python/pyspark /opt/spark/python/pyspark/; \
    mv python/lib /opt/spark/python/lib/; \
    cd ..; \
    rm -rf "$SPARK_TMP";

COPY entrypoint.sh /opt/

COPY articles.json /opt/

ENV SPARK_HOME /opt/spark

RUN curl https://repo1.maven.org/maven2/org/mongodb/spark/mongo-spark-connector_2.12/10.3.0/mongo-spark-connector_2.12-10.3.0.jar --output /opt/spark/jars/mongo-spark-connector_2.12-10.3.0.jar

RUN curl https://repo1.maven.org/maven2/org/mongodb/mongodb-driver-sync/4.8.1/mongodb-driver-sync-4.8.1.jar --output /opt/spark/jars/mongodb-driver-sync-4.8.1.jar

RUN curl https://repo1.maven.org/maven2/org/mongodb/bson/4.8.1/bson-4.8.1.jar --output /opt/spark/jars/bson-4.8.1.jar

RUN curl https://repo1.maven.org/maven2/org/mongodb/mongodb-driver-core/4.8.1/mongodb-driver-core-4.8.1.jar --output /opt/spark/jars/mongodb-driver-core-4.8.1.jar

RUN curl https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.3_2.12/1.5.2/iceberg-spark-runtime-3.3_2.12-1.5.2.jar --output /opt/spark/jars/iceberg-spark-runtime-3.3_2.12-1.5.2.jar

RUN curl https://repo1.maven.org/maven2/org/mongodb/bson-record-codec/4.8.1/bson-record-codec-4.8.1.jar --output /opt/spark/jars/bson-record-codec-4.8.1.jar

RUN curl https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/1.4.3/iceberg-aws-bundle-1.4.3.jar --output /opt/spark/jars/iceberg-aws-bundle-1.4.3.jar

RUN chown -R spark:spark /opt/spark/jars

RUN pip install requests boto3 botocore

WORKDIR /opt/spark/work-dir
RUN chmod g+w /opt/spark/work-dir
RUN chmod a+x /opt/decom.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]
