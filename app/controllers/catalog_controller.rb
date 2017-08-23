# frozen_string_literal: true
class CatalogController < ApplicationController

  include Blacklight::Catalog

  configure_blacklight do |config|

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
        qt: 'search',
        fq: '-class_name:Repository +portal_names_sms:"The Digital Library of Georgia"'
    }

    # facets are defined in query handler so this is not needed
    # makes debugging solr calls easier
    config.add_facet_fields_to_solr_request!

    # set maximum results per page (experimental)
    config.max_per_page = 20000

    # items to show per page, each number in the array represent another option to choose from.
    config.per_page = [20,50,100,1000]

    # solr field configuration for search results/index views
    config.index.title_field = 'title'
    config.index.display_type_field = 'format'

    # solr field configuration for document/show views
    config.show.title_field = 'title'
    config.show.display_type_field = 'format'

    # show thumbnails on search results for most view types
    # config.index.thumbnail_field = :thumbnail_url
    config.index.thumbnail_method = :record_thumbnail

    # FACETS
    config.add_facet_field 'provenance_facet',        label: I18n.t('search.facets.provenance'), limit: true
    config.add_facet_field 'publisher_facet',         label: I18n.t('search.facets.publisher'), limit: true
    config.add_facet_field 'creator_facet',           label: I18n.t('search.facets.creator'), limit: true
    config.add_facet_field 'contributor_facet',       label: I18n.t('search.facets.contributor'), limit: true
    config.add_facet_field 'subject_facet',           label: I18n.t('search.facets.subject'), limit: true
    config.add_facet_field 'subject_personal_facet',  label: I18n.t('search.facets.subject_personal'), limit: true
    config.add_facet_field 'year_facet',              label: I18n.t('search.facets.year'), limit: true
    config.add_facet_field 'temporal_facet',          label: I18n.t('search.facets.temporal'), limit: true
    config.add_facet_field 'location_facet',          label: I18n.t('search.facets.location'), limit: true
    config.add_facet_field 'format_facet',            label: I18n.t('search.facets.format'), limit: true
    config.add_facet_field 'rights_facet',            label: I18n.t('search.facets.rights'), limit: true, helper_method: :rights_icon_label
    config.add_facet_field 'rights_holder_facet'    , label: I18n.t('search.facets.rights_holder'), limit: true
    config.add_facet_field 'relation_facet',          label: I18n.t('search.facets.relation'), limit: true
    config.add_facet_field 'type_facet',              label: I18n.t('search.facets.type'), limit: true
    config.add_facet_field 'medium_facet',            label: I18n.t('search.facets.medium'), limit: true
    config.add_facet_field 'language_facet',          label: I18n.t('search.facets.language'), limit: true
    config.add_facet_field 'repository_name_sms',     label: I18n.t('search.facets.repository'), limit: true
    config.add_facet_field 'collection_name_sms',     label: I18n.t('search.facets.collection'), limit: true
    config.add_facet_field 'class_name',              label: I18n.t('search.facets.class'), limit: true

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'record_id_ss',                label: I18n.t('search.labels.record_id')
    config.add_index_field 'dcterms_title_display',       label: I18n.t('search.labels.dcterms_title')
    config.add_index_field 'dcterms_description_display', label: I18n.t('search.labels.dcterms_description'), helper_method: 'truncate_index'
    config.add_index_field 'collection_name_sms',         label: I18n.t('search.labels.collection'), link_to_search: true
    config.add_index_field 'repository_name_sms',         label: I18n.t('search.labels.repository'), link_to_search: true
    config.add_index_field 'dcterms_identifier_display',  label: I18n.t('search.labels.dcterms_identifier')
    config.add_index_field 'edm_is_shown_at_display',     label: I18n.t('search.labels.edm_is_shown_at'), helper_method: 'linkify'
    config.add_index_field 'edm_is_shown_by_display',     label: I18n.t('search.labels.edm_is_shown_by'), helper_method: 'linkify'
    config.add_index_field 'dcterms_creator_display',     label: I18n.t('search.labels.dcterms_creator'), link_to_search: :creator_facet
    config.add_index_field 'dc_format_display',           label: I18n.t('search.labels.dc_format'), link_to_search: :format_facet
    config.add_index_field 'dcterms_spatial_display',     label: I18n.t('search.labels.dcterms_spatial'), link_to_search: :location_facet

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'slug_ss',                                label: I18n.t('search.labels.item_id')
    config.add_show_field 'record_id_ss',                           label: I18n.t('search.labels.record_id')
    config.add_show_field 'dcterms_title_display',                  label: I18n.t('search.labels.dcterms_title')
    config.add_show_field 'collection_name_sms',                    label: I18n.t('search.labels.collection'), link_to_search: true
    config.add_show_field 'repository_name_sms',                    label: I18n.t('search.labels.repository'), link_to_search: true
    config.add_show_field 'dcterms_is_part_of_display',             label: I18n.t('search.labels.dcterms_is_part_of')
    config.add_show_field 'dcterms_description_display',            label: I18n.t('search.labels.dcterms_description')
    config.add_show_field 'dc_format_display',                      label: I18n.t('search.labels.dc_format')
    config.add_show_field 'dcterms_identifier_display',             label: I18n.t('search.labels.dcterms_identifier')
    config.add_show_field 'dc_right_display',                       label: I18n.t('search.labels.dc_right'), helper_method: 'rights_icon_tag'
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
    config.add_show_field 'dlg_subject_personal_display',           label: I18n.t('search.labels.dlg_subject_personal')
    config.add_show_field 'created_at_dts',                         label: I18n.t('search.labels.created_at')
    config.add_show_field 'updated_at_dts',                         label: I18n.t('search.labels.updated_at')

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, title_sort asc', label: 'Relevance'
    config.add_sort_field 'year asc', label: 'Year'
    config.add_sort_field 'title_sort asc', label: 'DC Title'
    config.add_sort_field 'collection_sort asc', label: 'Collection'
    config.add_sort_field 'creator_sort asc', label: 'DC Creator'
    config.add_sort_field 'created_at_dts desc', label: 'Latest Created'
    config.add_sort_field 'updated_at_dts desc', label: 'Latest Updated'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'
  end
end
