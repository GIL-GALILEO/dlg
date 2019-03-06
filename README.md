# Digital Library of Georgia

A Blacklight-powered frontend for the DLG's Georgia content.

Queries and displays data from the DLG's `meta` database and search index, which is managed by the [Meta administrative app](https://github.com/GIL-GALILEO/meta).

Project is also [on Github](https://github.com/GIL-GALILEO/dlg/)

### Requirements

- Ruby 2.3.4
- Vagrant

### Development Setup

1. Install Ruby
    1. [Install rbenv](https://github.com/rbenv/rbenv-installer#rbenv-installer)
    2. Install Ruby `2.3.4` using `rbenv install 2.3.4`
2. Clone repo
3. Get or create a `secrets.yml` file from someone special (see `config/secrets.yml.template`)
4. `vagrant up` - includes database and solr index
5. Install application gems using `bundle install`
6. Setup database tables using `rake db:setup`
7. Index sample data using `./reload_solr_data.sh`
6. `rails s` to start development server
7. Visit [localhost:3000](http://localhost:3000)
