class CollectionController < CatalogController

  configure_blacklight do |config|
    config.search_builder_class = CollectionSearch

    # Facets
    config.add_facet_field 'provenance_facet',        label: I18n.t('search.facets.provenance'), limit: true
    config.add_facet_field 'publisher_facet',         label: I18n.t('search.facets.publisher'), limit: true
    config.add_facet_field 'creator_facet',           label: I18n.t('search.facets.creator'), limit: true
    config.add_facet_field 'contributor_facet',       label: I18n.t('search.facets.contributor'), limit: true
    config.add_facet_field 'subject_facet',           label: I18n.t('search.facets.subject'), limit: true
    config.add_facet_field 'year_facet',              label: I18n.t('search.facets.year'), limit: true
    config.add_facet_field 'location_facet',          label: I18n.t('search.facets.location'), limit: true
    config.add_facet_field 'format_facet',            label: I18n.t('search.facets.format'), limit: true
    config.add_facet_field 'rights_facet',            label: I18n.t('search.facets.rights'), limit: true, helper_method: :rights_icon_label
    config.add_facet_field 'type_facet',              label: I18n.t('search.facets.type'), limit: true
    config.add_facet_field 'medium_facet',            label: I18n.t('search.facets.medium'), limit: true
    config.add_facet_field 'language_facet',          label: I18n.t('search.facets.language'), limit: true
    config.add_facet_field 'time_periods_sms',        label: I18n.t('search.facets.time_periods'), limit: true
    config.add_facet_field 'subjects_sms',            label: I18n.t('search.facets.subjects'), limit: true

    # Results Fields
    config.add_index_field 'dcterms_title_display',       label: I18n.t('search.labels.dcterms_title')
    config.add_index_field 'dcterms_description_display', label: I18n.t('search.labels.dcterms_description'), helper_method: :truncate_index
    config.add_index_field 'edm_is_shown_at_display',     label: I18n.t('search.labels.edm_is_shown_at'), helper_method: :linkify
    config.add_index_field 'edm_is_shown_by_display',     label: I18n.t('search.labels.edm_is_shown_by'), helper_method: :linkify
    config.add_index_field 'dcterms_creator_display',     label: I18n.t('search.labels.dcterms_creator'), link_to_search: :creator_facet
    config.add_index_field 'dc_format_display',           label: I18n.t('search.labels.dc_format'), link_to_search: :format_facet

    config.show.html_title = 'title_display'

    config.add_sort_field 'title_sort asc', label: I18n.t('search.sort.collection_title')
    config.add_sort_field 'created_at_dts desc', label: I18n.t('search.sort.newest')

  end

end