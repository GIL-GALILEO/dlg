# Digital Library of Georgia

A Blacklight-powered frontend for the DLG's Georgia content.

Queries and displays data from the DLG's `meta` database and search index, which is managed by the [Meta administrative app](https://github.com/GIL-GALILEO/meta).

Project is also [on Github](https://github.com/GIL-GALILEO/dlg/)

### Requirements

- Ruby 2.3.4
- Vagrant

### Development Setup

For Ubuntu 16.04

0. You may need some packages...
    1. `sudo apt-get update`
    2. `sudo apt-get install gcc build-essential libssl-dev libreadline-dev zlib1g-dev libpq-dev`
1. Install Ruby
    1. [Install rbenv](https://github.com/rbenv/rbenv-installer#rbenv-installer), ensure `rbenv` binaries are on your `$PATH`
    2. Install Ruby `2.3.4` using `rbenv install 2.3.4`
    3. Finish [setting up `rbenv`](https://github.com/rbenv/rbenv#installation)
2. Install [Vagrant](https://www.vagrantup.com/downloads.html)
    1. You may also need to install VirtualBox via `sudo apt-get install virtualbox`
3. Clone repo
4. Get or create a `secrets.yml` file from someone special (see `config/secrets.yml.template`)
5. `vagrant up` - includes database and solr index
6. Install application gems
    1. `gem install bundler`
    2. `bundle install`
7. Setup database tables using `rake db:setup`
8. Index sample data using `./reload_solr_data.sh`
9. `rails s` to start development server
10. Visit [localhost:3000](http://localhost:3000)
