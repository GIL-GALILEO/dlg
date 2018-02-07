# frozen_string_literal: true

# Main Blacklight search controller
class RecordsController < CatalogController
  include BlacklightMaps::ControllerOverride

  configure_blacklight do |config|
    config.search_builder_class = RecordsSearch

    # FACETS
    config.add_facet_field :counties_facet,              label: I18n.t('search.facets.county'), limit: true, display: false, group: 'item'
    config.add_facet_field :provenance_facet,            label: I18n.t('search.facets.provenance'), limit: true, group: 'item'
    config.add_facet_field :subject_facet,               label: I18n.t('search.facets.subject'), limit: true, group: 'item'
    config.add_facet_field :year_facet,                  label: I18n.t('search.facets.year'), limit: true, group: 'item'
    config.add_facet_field :location_facet,              label: I18n.t('search.facets.location'), limit: true, group: 'item', helper_method: :spatial_cleaner
    config.add_facet_field :rights_facet,                label: I18n.t('search.facets.rights'), limit: true, helper_method: :rights_icon_label, group: 'item'
    config.add_facet_field :type_pivot_facet,            label: I18n.t('search.facets.medium'), limit: true, group: 'item', pivot: ['type_facet', 'medium_facet']
    config.add_facet_field :collection_name_sms,         label: I18n.t('search.facets.collection_name'), limit: true, group: 'item'
    config.add_facet_field :time_periods_sms,            label: I18n.t('search.facets.time_periods'), limit: true, group: 'collection'
    config.add_facet_field :subjects_sms,                label: I18n.t('search.facets.subjects'), limit: true, group: 'collection'

    # hidden facet fields
    config.add_facet_field :medium_facet,                label: '_', limit: true, show: false

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field :dcterms_provenance,           label: I18n.t('search.labels.dcterms_provenance'), link_to_search: :provenance_facet
    config.add_index_field :dcterms_subject,              label: I18n.t('search.labels.dcterms_subject'), link_to_search: true
    config.add_index_field :dcterms_description_display,  label: I18n.t('search.labels.dcterms_description'), helper_method: :truncate_index
    config.add_index_field :edm_is_shown_at_display,      label: I18n.t('search.labels.edm_is_shown_at'), helper_method: :linkify
    config.add_index_field :dc_date,                      label: I18n.t('search.labels.dc_date')

    # Show Page Fields
    config.add_show_field 'dcterms_provenance_display',             label: I18n.t('search.labels.dcterms_provenance'), link_to_search: :provenance_facet
    config.add_show_field 'dcterms_creator_display',                label: I18n.t('search.labels.dcterms_creator'), link_to_search: :creator_facet
    config.add_show_field 'dcterms_contributor_display',            label: I18n.t('search.labels.dcterms_contributor')
    config.add_show_field 'dcterms_subject_display',                label: I18n.t('search.labels.dcterms_subject'), link_to_search: :subject_facet
    config.add_show_field 'dcterms_description_display',            label: I18n.t('search.labels.dcterms_description')
    config.add_show_field 'dcterms_identifier_display',             label: I18n.t('search.labels.dcterms_identifier')
    config.add_show_field 'dcterms_publisher_display',              label: I18n.t('search.labels.dcterms_publisher')
    config.add_show_field 'edm_is_shown_at_display',                label: I18n.t('search.labels.edm_is_shown_at'), helper_method: 'linkify'
    config.add_show_field 'edm_is_shown_by_display',                label: I18n.t('search.labels.edm_is_shown_by'), helper_method: 'linkify'
    config.add_show_field 'dc_date_display',                        label: I18n.t('search.labels.dc_date')
    config.add_show_field 'dcterms_temporal_display',               label: I18n.t('search.labels.dcterms_temporal')
    config.add_show_field 'dcterms_spatial_display',                label: I18n.t('search.labels.dcterms_spatial'), link_to_search: :location_facet
    config.add_show_field 'dc_format_display',                      label: I18n.t('search.labels.dc_format')
    config.add_show_field 'dcterms_is_part_of_display',             label: I18n.t('search.labels.dcterms_is_part_of')
    config.add_show_field 'dc_right_display',                       label: I18n.t('search.labels.dc_right'), helper_method: :rights_icon_tag
    config.add_show_field 'dcterms_rights_holder_display',          label: I18n.t('search.labels.dcterms_rights_holder')
    config.add_show_field 'dcterms_type_display',                   label: I18n.t('search.labels.dcterms_type')
    config.add_show_field 'dcterms_medium_display',                 label: I18n.t('search.labels.dcterms_medium')
    config.add_show_field 'dcterms_extent_display',                 label: I18n.t('search.labels.dcterms_extent')
    config.add_show_field 'dcterms_language_display',               label: I18n.t('search.labels.dcterms_language')
    config.add_show_field 'dcterms_bibliographic_citation_display', label: I18n.t('search.labels.dcterms_bibliographic_citation')
    config.add_show_field 'dlg_local_right',                        label: I18n.t('search.labels.dlg_local_right')
    config.add_show_field 'collection_name_sms',                    label: I18n.t('search.labels.collection'), link_to_search: true
    # config.add_show_field 'dc_relation_display',                    label: I18n.t('search.labels.dc_relation')
    # config.add_show_field 'dcterms_title_display',                  label: I18n.t('search.labels.dcterms_title')
    # config.add_show_field 'record_id_ss',                           label: I18n.t('search.labels.record_id')

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'title_sort asc', label: I18n.t('search.sort.title')
    config.add_sort_field 'created_at_dts desc', label: I18n.t('search.sort.newest')
    config.add_sort_field 'score desc, title_sort asc', label: I18n.t('search.sort.relevance')
    config.add_sort_field 'class_name_ss asc, title_sort asc', label: I18n.t('search.sort.collections_first')

    # define search fields
    # title
    config.add_search_field('title') do |field|
      field.label = I18n.t('search.labels.dcterms_title')
      field.solr_local_parameters = {
        qf: 'title_unstem_search^1000 dcterms_title_text^50',
        pf: 'title_unstem_search^1000 dcterms_title_text^50'
      }
    end
    # description
    config.add_search_field('description') do |field|
      field.label = I18n.t('search.labels.dcterms_description')
      field.solr_local_parameters = {
        qf: 'description_unstem_search^1000 dcterms_description_text^50',
        pf: 'description_unstem_search^1000 dcterms_description_text^50'
      }
    end
    # collection name
    config.add_search_field('collection_name') do |field|
      field.label = I18n.t('search.labels.collection')
      field.solr_local_parameters = {
        qf: 'collection_name_sms',
        pf: 'collection_name_sms'
      }
    end
    # creator
    config.add_search_field('creator') do |field|
      field.label = I18n.t('search.labels.dcterms_creator')
      field.solr_local_parameters = {
        qf: 'dcterms_creator_text^500',
        pf: 'dcterms_creator_text^500'
      }
    end
    # subject
    config.add_search_field('subject') do |field|
      field.label = I18n.t('search.labels.dcterms_subject')
      field.solr_local_parameters = {
        qf: 'subject_unstem_search^1000 dcterms_subject_text^50',
        pf: 'subject_unstem_search^1000 dcterms_subject_text^50'
      }
    end
    # provenance
    config.add_search_field('provenance') do |field|
      field.label = I18n.t('search.labels.dcterms_provenance')
      field.solr_local_parameters = {
        qf: 'dcterms_provenance_text^500',
        pf: 'dcterms_provenance_text^500'
      }
    end
    # place
    config.add_search_field('spatial') do |field|
      field.label = I18n.t('search.labels.dcterms_spatial')
      field.solr_local_parameters = {
        qf: 'spatial_unstem_search^1000 dcterms_spatial_text^50',
        pf: 'spatial_unstem_search^1000 dcterms_spatial_text^50'
      }
    end

    # maps config values
    config.add_facet_field 'geojson', label: '_', limit: -2, show: false
    config.view.maps.geojson_field = 'geojson'
    config.view.maps.placename_field = 'placename'
    config.view.maps.coordinates_field = 'coordinates'
    config.view.maps.search_mode = 'placename'
    config.view.maps.facet_mode = 'geojson'
    config.view.maps.initialview = '[[30.164126,-88.516846],[35.245619,-78.189697]]'
    config.view.maps.tileurl = 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
    config.view.maps.maxzoom = 12
    config.view.maps.show_initial_zoom = 10
    config.show.partials << :show_maplet

    # gallery config
    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]
    # config.view.slideshow.partials = [:index]
    # config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    # config.show.partials.insert(1, :openseadragon)

    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    # config.advanced_search[:qt] ||= 'advanced'
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'dismax'
    config.advanced_search[:form_facet_partial]   ||= 'advanced_search_facets_as_select'
    config.advanced_search[:form_solr_parameters] ||= {
      'f.county_facet.facet.limit' => -1,
      'f.provenance_facet.facet.limit' => 250,
      'f.subject_facet.facet.limit' => 250,
      'f.year_facet.facet.limit' => 250,
      'f.location_facet.facet.limit' => 250,
      'f.rights_facet.facet.limit' => 250,
      'f.type_facet.facet.limit' => 250,
      'f.medium_facet.facet.limit' => 250,
      'f.time_periods_sms.facet.limit' => -1,
      'f.subjects_sms.facet.limit' => -1,
      'f.collection_name_sms.facet.limit' => -1
    }
  end

  def collection?(_, doc)
    doc['class_name_ss'] == 'Collection'
  end

end