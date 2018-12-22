# Digital Library of Georgia

A Blacklight-powered frontend for the DLG's Georgia content.

Queries and displays data from the DLG's `meta` database and search index, which is managed by the [Meta administrative app](https://github.com/GIL-GALILEO/meta).

Project is also [on Github](https://github.com/GIL-GALILEO/dlg/)

### Requirements

- Ruby 2.3.4
- Vagrant

### Development Setup

1. Install Ruby and Vagrant
2. Clone repo
3. Get or create a `secrets.yml` file
4. `vagrant up` - includes database and solr index
5. `rails s`
