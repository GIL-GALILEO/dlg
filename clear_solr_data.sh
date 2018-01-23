#!/usr/bin/env bash

curl 'http://localhost:6983/solr/meta-dev/update?stream.body=<delete><query>*:*</query></delete>&commit=true'
curl 'http://localhost:6983/solr/meta-test/update?stream.body=<delete><query>*:*</query></delete>&commit=true'