# docker ELK
原文  ：https://www.itread01.com/content/1545621852.html

## **EFK**
- Elasticsearch是一個數據搜尋引擎和分散式NoSQL資料庫的組合，提過日誌的儲存和搜尋功能。Fluentd是一個訊息採集，轉化，轉發工具，目的是提供中心化的日誌服務。Kibana是一個帶有強大資料整理，分析的web前端，將資料以視覺化的方式呈現給使用者。

**注意：**

- docker hub 上 elastic 不再更新，直接去[elastic官網](https://www.docker.elastic.co/)
- fluend image from dokcer hub

所需port : 9200 , 5601
所需環境 docker  , git 

    #for amz-linux2 
    $ sudo yum install -y docker-18.06.1ce-10.32.amzn1.x86_64
    $ sudo yum install git-2.14.5-1.60.amzn1.x86_64

下載 git repositories

    $ git clone https://github.com/guan840912/docker-ELK.git && cd docker-ELK

下載images，已寫好腳本，執行  ./d.sh

    $ ./d.sh
    ======================================================================
    set -x
    
    docker pull docker.elastic.co/elasticsearch/elasticsearch:6.5.4
    
    docker pull docker.elastic.co/kibana/kibana:6.5.4
    
    docker pull fluent/fluentd:v1.3.2-debian-1.0
    
    exit 0

**FLUENTD需要安裝ELASTICSEARCH外掛**

    $ cat Dockerfile
    ===================================================================
    FROM fluent/fluentd:v1.3.2-debian-1.0
    RUN ["gem", "install", "fluent-plugin-elasticsearch"]
    ===================================================================
    執行docker build
    $ docker build -t fluentd:1.3.2 .

**執行容器**

    在docker-ELK 資料夾下。執行以下指令
    
    $ docker create --network host --name elasticsearch -e discovery.type=single-node --restart always docker.elastic.co/elasticsearch/elasticsearch:6.5.4
    
    #{docker-ELK 資料夾所在地}/work/elk/conf:/fluentd/etc
    $ docker create --network host --name fluentd -v $(pwd)/work/elk/conf:/fluentd/etc --restart always fluentd:1.3.2
    
    $ docker create --network host --name kibana -e ELASTICSEARCH_URL=http://127.0.0.1:9200 --restart always docker.elastic.co/kibana/kibana:6.5.4
    
    #啟動容器 稍等 一下
    docker start elasticsearch  fluentd  kibana 

cat docker-ELK/work/elk/conf/fluent.conf

    #fluent.conf
    
    <source>
    @type forward
    port 24224
    bind 0.0.0.0
    </source>
    <match *.**>
    @type copy
    <store>
    @type elasticsearch
    host 127.0.0.1
    port 9200
    logstash_format true
    logstash_prefix fluentd
    logstash_dateformat %Y%m%d
    include_tag_key true
    type_name access_log
    tag_key @log_name
    flush_interval 1s
    </store>
    <store>
    @type stdout
    </store>
    </match>

訪問 http://127.0.0.1:5601 ; http://host_ip:5601

![](https://paper-attachments.dropbox.com/s_702A3FDEF732D20211E33F037BCA8FE64052CBFE5B4C867C8FEC62C461778CD1_1567134055817_image.png)


