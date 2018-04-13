# frozen_string_literal: true

# Blacklight search controller for Collections
class CollectionsController < CatalogController
  include BlacklightMaps::ControllerOverride

  configure_blacklight do |config|
    config.search_builder_class = CollectionSearch

    # Facets
    config.add_facet_field :creator_facet,           label: I18n.t('search.facets.creator'), limit: true
    config.add_facet_field :subject_facet,           label: I18n.t('search.facets.subject'), limit: true
    config.add_facet_field :location_facet,          label: I18n.t('search.facets.location'), limit: true, helper_method: :spatial_cleaner
    config.add_facet_field :counties_facet,          label: I18n.t('search.facets.county'), limit: true
    config.add_facet_field :year_facet,              label: I18n.t('search.facets.year'), limit: true
    config.add_facet_field :medium_facet,            label: I18n.t('search.facets.medium'), limit: true
    config.add_facet_field :type_facet,              label: I18n.t('search.facets.type'), limit: true, helper_method: :type_cleaner
    config.add_facet_field :rights_facet,            label: I18n.t('search.facets.rights'), limit: true, helper_method: :rights_icon_label
    config.add_facet_field :provenance_facet,        label: I18n.t('search.facets.provenance'), limit: true
    config.add_facet_field :subjects_sms,            label: I18n.t('search.facets.subjects'), limit: true
    config.add_facet_field :time_periods_sms,        label: I18n.t('search.facets.time_periods'), limit: true

    # Results Fields
    config.add_index_field :dcterms_provenance,           label: I18n.t('search.labels.dcterms_provenance'), link_to_search: true
    config.add_index_field :short_description_display,    label: I18n.t('search.labels.short_description'), helper_method: :strip_html

    # Show Fields
    config.add_show_field :dcterms_creator_display,                label: I18n.t('search.labels.dcterms_creator'), link_to_search: :creator_facet
    config.add_show_field :dcterms_contributor_display,            label: I18n.t('search.labels.dcterms_contributor')
    config.add_show_field :dcterms_publisher_display,              label: I18n.t('search.labels.dcterms_publisher')
    config.add_show_field :dc_date_display,                        label: I18n.t('search.labels.dc_date')
    config.add_show_field :dcterms_temporal_display,               label: I18n.t('search.labels.dcterms_temporal')
    config.add_show_field :dcterms_subject_display,                label: I18n.t('search.labels.dcterms_subject'), link_to_search: :subject_facet
    config.add_show_field :subjects_sms,                           label: I18n.t('search.labels.subjects')
    config.add_show_field :dcterms_spatial_display,                label: I18n.t('search.labels.dcterms_spatial'), link_to_search: :location_facet
    config.add_show_field :dcterms_medium_display,                 label: I18n.t('search.labels.dcterms_medium'), link_to_search: :medium_facet
    config.add_show_field :dcterms_type_display,                   label: I18n.t('search.labels.dcterms_type')
    config.add_show_field :dc_format_display,                      label: I18n.t('search.labels.dc_format')
    config.add_show_field :dcterms_description_display,            label: I18n.t('search.labels.dcterms_description')
    config.add_show_field :dcterms_identifier_display,             label: I18n.t('search.labels.dcterms_identifier')
    config.add_show_field :edm_is_shown_at_display,                label: I18n.t('search.labels.edm_is_shown_at'), helper_method: :linkify
    config.add_show_field :edm_is_shown_by_display,                label: I18n.t('search.labels.edm_is_shown_by'), helper_method: :linkify
    config.add_show_field :dcterms_language_display,               label: I18n.t('search.labels.dcterms_language')
    config.add_show_field :dcterms_rights_holder_display,          label: I18n.t('search.labels.dcterms_rights_holder')
    config.add_show_field :dlg_local_right,                        label: I18n.t('search.labels.dlg_local_right')
    config.add_show_field :dcterms_bibliographic_citation_display, label: I18n.t('search.labels.dcterms_bibliographic_citation')
    config.add_show_field :dcterms_is_part_of_display,             label: I18n.t('search.labels.dcterms_is_part_of')
    config.add_show_field :dcterms_provenance_display,             label: I18n.t('search.labels.dcterms_provenance'), link_to_search: :provenance_facet
    config.add_show_field :dc_right_display,                       label: I18n.t('search.labels.dc_right'), helper_method: :rights_icon_tag

    config.show.html_title = 'title_display'

    config.add_sort_field 'score desc, title_sort asc', label: I18n.t('search.sort.relevance')
    config.add_sort_field 'title_sort asc', label: I18n.t('search.sort.collection_title')
    config.add_sort_field 'year asc', label: I18n.t('search.sort.date')
    # config.add_sort_field 'created_at_dts desc', label: I18n.t('search.sort.newest')

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

  end

end