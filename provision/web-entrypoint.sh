#!/bin/bash
wget --quiet https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2
cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /bin/
apt-get update -qq && apt-get -y install nodejs
bundle install
bundle exec rake db:setup RAILS_ENV=test
bundle exec rspec --color --format documentation