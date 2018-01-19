#!/usr/bin/env bash

curl 'http://localhost:6983/solr/meta-dev/update?commit=true' --data-binary '@provision/data.json' -H 'Content-type:application/json'
curl 'http://localhost:6983/solr/meta-test/update?commit=true' --data-binary '@provision/data.json' -H 'Content-type:application/json'