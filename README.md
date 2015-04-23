# API

## Setup

    gem install bundler
    bundle install
    createuser -d -P -e test
    createdb --username=test -W --owner=test -e api_test
    \copy ad_statistics FROM '/path/to/ad_statistics.tsv';
    \copy ad_actions FROM '/path/to/ad_actions.tsv';

## Run tests

    rspec

## Run

    ruby api.rb

## Optimize DB performance

* use replication and setup slaves (http://docs.memsql.com/docs/latest/admin/replication.html)
* release connection when done
* use database connection pooling (http://en.wikipedia.org/wiki/Connection_pool)
* might give VARCHAR a length or use INT for count/value
* hash index on ad_id, skip list index on date, descending
