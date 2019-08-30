FROM fluent/fluentd:v1.3.2-debian-1.0
RUN ["gem", "install", "fluent-plugin-elasticsearch"]
