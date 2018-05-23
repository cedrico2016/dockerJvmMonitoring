#!/bin/bash

JMXTRANS_CONFIG="/var/lib/jmxtrans/influxwriter.json"

cat <<EOF > $JMXTRANS_CONFIG
{
  "servers": [
    {
      "host": "${JMX_HOST}",
      "port": "${JMX_PORT}",
      "queries": [
        {
          "obj": "java.lang:type=Memory",
          "attr": [ "HeapMemoryUsage", "NonHeapMemoryUsage" ],
          "resultAlias":"jvmMemory",
          "outputWriters": [
            {
              "@class": "com.googlecode.jmxtrans.model.output.InfluxDbWriterFactory",
              "url" : "http://${INFLUXDB_HOST}:${INFLUXDB_PORT}/",
              "username" : "${INFLUXDB_USER}",
              "password" : "${INFLUXDB_PASSWD}",
              "database" : "jmxdb",
              "tags" : {"application" : "testApp"}
            }
          ]
        }
      ]
    }
  ]
}
EOF


/docker-entrypoint.sh start-with-jmx
