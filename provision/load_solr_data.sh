#!/usr/bin/env bash

curl http://localhost:6983/solr/meta-dev/update?commit=true -d  '<delete><query>*:*</query></delete>'
curl http://localhost:6983/solr/meta-test/update?commit=true -d  '<delete><query>*:*</query></delete>'

curl -X POST 'http://localhost:6983/solr/meta-dev/update/json?commit=true' --data-binary @data.json -H 'Content-type:application/json'
curl -X POST 'http://localhost:6983/solr/meta-test/update/json?commit=true' --data-binary @data.json -H 'Content-type:application/json'
