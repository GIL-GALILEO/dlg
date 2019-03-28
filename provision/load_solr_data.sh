#!/usr/bin/env bash

curl http://solr:8983/solr/meta-dev/update?commit=true -d  '<delete><query>*:*</query></delete>'
curl http://solr:8983/solr/meta-test/update?commit=true -d  '<delete><query>*:*</query></delete>'

curl -X POST 'http://solr:8983/solr/meta-dev/update/json?commit=true' --data-binary @data.json -H 'Content-type:application/json'
curl -X POST 'http://solr:8983/solr/meta-test/update/json?commit=true' --data-binary @data.json -H 'Content-type:application/json'
