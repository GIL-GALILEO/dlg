# frozen_string_literal: true

# Main Blacklight controller housing common configuration shared with other
# child Controllers
class CatalogController < ApplicationController
  include BlacklightAdvancedSearch::Controller

  include Blacklight::Catalog

  configure_blacklight do |config|
    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    # config.advanced_search[:qt] ||= 'advanced'
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'dismax'
    config.advanced_search[:form_solr_parameters] ||= {}


    # Default parameters to send to solr for all search-like requests.
    # See also SearchBuilder#processed_parameters
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

    # Show Page Fields
    config.add_show_field 'record_id_ss',                           label: I18n.t('search.labels.record_id')
    config.add_show_field 'dcterms_title_display',                  label: I18n.t('search.labels.dcterms_title')
    config.add_show_field 'collection_name_sms',                    label: I18n.t('search.labels.collection'), link_to_search: true
    config.add_show_field 'repository_name_sms',                    label: I18n.t('search.labels.repository'), link_to_search: true
    config.add_show_field 'dcterms_is_part_of_display',             label: I18n.t('search.labels.dcterms_is_part_of')
    config.add_show_field 'dcterms_description_display',            label: I18n.t('search.labels.dcterms_description')
    config.add_show_field 'dc_format_display',                      label: I18n.t('search.labels.dc_format')
    config.add_show_field 'dcterms_identifier_display',             label: I18n.t('search.labels.dcterms_identifier')
    config.add_show_field 'dc_right_display',                       label: I18n.t('search.labels.dc_right')
    config.add_show_field 'dc_date_display',                        label: I18n.t('search.labels.dc_date')
    config.add_show_field 'dc_relation_display',                    label: I18n.t('search.labels.dc_relation')
    config.add_show_field 'dcterms_publisher_display',              label: I18n.t('search.labels.dcterms_publisher')
    config.add_show_field 'dcterms_contributor_display',            label: I18n.t('search.labels.dcterms_contributor')
    config.add_show_field 'dcterms_temporal_display',               label: I18n.t('search.labels.dcterms_temporal')
    config.add_show_field 'dcterms_spatial_display',                label: I18n.t('search.labels.dcterms_spatial'), link_to_search: :location_facet
    config.add_show_field 'dcterms_provenance_display',             label: I18n.t('search.labels.dcterms_provenance')
    config.add_show_field 'dcterms_subject_display',                label: I18n.t('search.labels.dcterms_subject'), link_to_search: :subject_facet
    config.add_show_field 'dcterms_type_display',                   label: I18n.t('search.labels.dcterms_type')
    config.add_show_field 'dcterms_creator_display',                label: I18n.t('search.labels.dcterms_creator'), link_to_search: :creator_facet
    config.add_show_field 'dcterms_language_display',               label: I18n.t('search.labels.dcterms_language')
    config.add_show_field 'edm_is_shown_at_display',                label: I18n.t('search.labels.edm_is_shown_at'), helper_method: 'linkify'
    config.add_show_field 'edm_is_shown_by_display',                label: I18n.t('search.labels.edm_is_shown_by'), helper_method: 'linkify'
    config.add_show_field 'dcterms_rights_holder_display',          label: I18n.t('search.labels.dcterms_rights_holder')
    config.add_show_field 'dcterms_bibliographic_citation_display', label: I18n.t('search.labels.dcterms_bibliographic_citation')
    config.add_show_field 'dcterms_extent_display',                 label: I18n.t('search.labels.dcterms_extent')
    config.add_show_field 'dcterms_medium_display',                 label: I18n.t('search.labels.dcterms_medium')

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

end
