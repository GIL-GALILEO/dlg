class CollectionsController < CatalogController
  include BlacklightMaps::ControllerOverride

  configure_blacklight do |config|
    config.search_builder_class = CollectionSearch

    # Facets
    config.add_facet_field 'provenance_facet',        label: I18n.t('search.facets.provenance'), limit: true
    config.add_facet_field 'publisher_facet',         label: I18n.t('search.facets.publisher'), limit: true
    config.add_facet_field 'creator_facet',           label: I18n.t('search.facets.creator'), limit: true
    config.add_facet_field 'contributor_facet',       label: I18n.t('search.facets.contributor'), limit: true
    config.add_facet_field 'subject_facet',           label: I18n.t('search.facets.subject'), limit: true
    config.add_facet_field 'year_facet',              label: I18n.t('search.facets.year'), limit: true
    config.add_facet_field 'location_facet',          label: I18n.t('search.facets.location'), limit: true, helper_method: :spatial_cleaner
    config.add_facet_field 'format_facet',            label: I18n.t('search.facets.format'), limit: true
    config.add_facet_field 'rights_facet',            label: I18n.t('search.facets.rights'), limit: true, helper_method: :rights_icon_label
    config.add_facet_field 'type_facet',              label: I18n.t('search.facets.type'), limit: true
    config.add_facet_field 'medium_facet',            label: I18n.t('search.facets.medium'), limit: true
    config.add_facet_field 'language_facet',          label: I18n.t('search.facets.language'), limit: true
    config.add_facet_field 'time_periods_sms',        label: I18n.t('search.facets.time_periods'), limit: true
    config.add_facet_field 'subjects_sms',            label: I18n.t('search.facets.subjects'), limit: true

    # Results Fields
    config.add_index_field :dcterms_provenance,           label: I18n.t('search.labels.dcterms_provenance'), link_to_search: true
    config.add_index_field :dcterms_description_display,  label: I18n.t('search.labels.dcterms_description'), helper_method: :truncate_index
    config.add_index_field :dc_date,                      label: I18n.t('search.labels.dc_date')
    config.add_index_field :edm_is_shown_at_display,      label: I18n.t('search.labels.edm_is_shown_at'), helper_method: :linkify

    # Show page fields are defined in RecordController

    config.show.html_title = 'title_display'

    config.add_sort_field 'title_sort asc', label: I18n.t('search.sort.collection_title')
    config.add_sort_field 'created_at_dts desc', label: I18n.t('search.sort.newest')

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