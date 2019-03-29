#!/bin/bash
groupadd -g 999 gitlab-runner && useradd -u 999 -g 999 -d . gitlab-runner
apt-get update -qq && apt-get -y install nodejs sudo
wget --quiet https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2
cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /bin/
bundle install
bundle exec rake db:setup RAILS_ENV=test
sudo -E -u gitlab-runner bundle exec rspec --color --format documentation