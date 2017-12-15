# frozen_string_literal: true

# Main Blacklight controller housing common configuration shared with other
# child Controllers
class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config|

    # Default parameters to send to solr for all search-like requests.
    # See also SearchBuilder#processed_parameters
    # config.default_solr_params = { qt: 'public' }
    config.default_solr_params = { qt: 'search' }

    # facets are defined in query handler so this is not needed
    # makes debugging solr calls easier
    config.add_facet_fields_to_solr_request!

    # set maximum results per page (experimental)
    config.max_per_page = 2000

    # items to show per page, each number in the array represent another option to choose from.
    config.per_page = [20, 50, 100, 1000]

    # solr field configuration for search results/index views
    config.index.title_field = 'title'
    config.index.display_type_field = 'class_name_ss'

    # solr field configuration for document/show views
    config.show.title_field = 'title'
    config.show.display_type_field = 'class_name_ss'

    # show thumbnails on search results for most view types
    # config.index.thumbnail_field = :thumbnail_url
    config.index.thumbnail_method = :record_thumbnail

    config.add_search_field('all_fields') do |field|
      # field.include_in_advanced_search = false # no results returned in advanced search
    end

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'
  end

  add_nav_action :collections
  add_nav_action :counties
  add_nav_action :institutions
  add_nav_action :map

end
