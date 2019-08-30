#!/bin/bash
set -x
docker pull docker.elastic.co/elasticsearch/elasticsearch:6.5.4

docker pull docker.elastic.co/kibana/kibana:6.5.4

docker pull fluent/fluentd:v1.3.2-debian-1.0

exit 0
