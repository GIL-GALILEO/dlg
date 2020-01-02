# frozen_string_literal: true

# Main Blacklight controller housing common configuration shared with other
# child Controllers
class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config|

    # Default parameters to send to solr for all search-like requests.
    # See also SearchBuilder#processed_parameters
    config.default_solr_params = { qt: 'search' }

    # TODO: facets are defined in query handler so this should not be needed
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
    # now handled in templates, see _show_item, _thumbnail_item, etc.
    # config.index.thumbnail_field = :thumbnail_url
    # config.index.thumbnail_method = :record_thumbnail

    config.add_search_field('metadata') do |field|
      field.label = I18n.t('search.labels.metadata')
      field.include_in_simple_select = true
      field.include_in_advanced_search = true
    end

    config.add_search_field('fulltext') do |field|
      field.label = I18n.t('search.labels.fulltext')
      field.include_in_advanced_search = true
      field.include_in_simple_select = true
      field.solr_local_parameters = {
        qf: 'fulltext_texts^1000',
        pf: 'fulltext_texts^1000'
      }
    end

    # fulltexty
    config.add_search_field('both') do |field|
      field.include_in_advanced_search = false
      field.include_in_simple_select = true
      field.label = I18n.t('search.labels.both')
      field.solr_local_parameters = {
        qf: 'fulltext_texts^150
             title_unstem_search^100
             creator_unstem_search^100
             contributor_unstem_search^100
             subject_unstem_search^100
             description_unstem_search^100
             publisher_unstem_search^100
             date_unstem_search^100
             temporal_unstem_search^100
             spatial_unstem_search^100
             is_part_of_unstem_search^100
             identifier_unstem_search^100
             edm_is_shown_at_text^100
             edm_is_shown_by_text^100
             collection_titles_unstem_search^100
             dcterms_title_text
             dcterms_creator_text
             dcterms_contributor_text
             dcterms_subject_text
             dcterms_description_text
             dcterms_publisher_text
             dcterms_temporal_text
             dcterms_spatial_text
             dcterms_is_part_of_text
             dcterms_identifier_text
             collection_titles_text'.squish,
        pf: 'fulltext_texts^150
             title_unstem_search^100
             creator_unstem_search^100
             contributor_unstem_search^100
             subject_unstem_search^100
             description_unstem_search^100
             publisher_unstem_search^100
             date_unstem_search^100
             temporal_unstem_search^100
             spatial_unstem_search^100
             is_part_of_unstem_search^100
             identifier_unstem_search^100
             edm_is_shown_at_text^100
             edm_is_shown_by_text^100
             collection_titles_unstem_search^100
             dcterms_title_text
             dcterms_creator_text
             dcterms_contributor_text
             dcterms_subject_text
             dcterms_description_text
             dcterms_publisher_text
             dcterms_temporal_text
             dcterms_spatial_text
             dcterms_is_part_of_text
             dcterms_identifier_text
             collection_titles_text'.squish
      }
    end

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = false
    config.autocomplete_path = 'suggest'
  end

  def sms_mappings
    {
      'Virgin' => 'vmobl.com',
      'AT&T' => 'txt.att.net',
      'Verizon' => 'vtext.com',
      'Nextel' => 'messaging.nextel.com',
      'Sprint' => 'messaging.sprintpcs.com',
      'T Mobile' => 'tmomail.net',
      'Alltel' => 'message.alltel.com',
      'Cricket' => 'mms.mycricket.com',
      'Google Fi' => 'msg.fi.google.com',
      'Boost Mobile' => 'myboostmobile.com',
      'Comcast' => 'comcastpcs.textmsg.com',
      'Metro PCS' => 'mymetropcs.com',
      'Tracfone' => 'txt.att.net',
      'US Cellular' => 'email.uscc.net',
      'Consumer Cellular' => 'txt.att.net'
    }
  end
end
