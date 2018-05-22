# frozen_string_literal: true

require 'sitemap_generator'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://dlg.usg.edu'

SitemapGenerator::Sitemap.create do

  # add '/', priority: 1
  add '/teach/using-materials', priority: 0.75
  add '/participate/contribute', priority: 0.75
  add '/participate/nominate', priority: 0.75
  add '/participate/partner-services', priority: 0.75
  add '/about/mission', priority: 0.75
  add '/about/policy', priority: 0.75
  add '/about/partners-sponsors', priority: 0.75

  # Add single record pages
  cursor = '*'
  loop do
    response = Blacklight.default_index.connection.get 'select', params: {
      rows: 1000,
      fl: 'id, updated_at_dts',
      fq: 'display_b:1, portals_sms:"georgia"',
      cursorMark: '*',
      sort: 'id asc'
    }
    response['response']['docs'].each do |doc|
      add "/record/#{doc['id']}", lastmod: doc['updated_at_dts'], priority: 0.5
    end
    break if response['nextCursorMark'] == cursor
    cursor = response['nextCursorMark']
  end
end
