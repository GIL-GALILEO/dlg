#!/bin/bash
groupadd -g 999 gitlab-runner && useradd -u 999 -g 999 gitlab-runner && usermod -d /code gitlab-runner
apt-get update -qq && apt-get -y install nodejs sudo
sudo -u gitlab-runner wget --quiet https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
sudo -u gitlab-runner tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2
cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /bin/
sudo -u gitlab-runner bundle install --path vendor/bundle
echo PATH=`pwd`/vendor/bundle/ruby/2.4.0/bin:$PATH
PATH=`pwd`/vendor/bundle/ruby/2.4.0/bin:$PATH sudo -u gitlab-runner bundle exec rake db:setup RAILS_ENV=test
sudo -E -u gitlab-runner bundle exec rspec --color --format documentation