class ItemController < CatalogController

  configure_blacklight do |config|
    config.search_builder_class = ItemSearch

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
    config.add_facet_field 'collection_name_sms',     label: I18n.t('search.facets.collection'), limit: true

    # Results fields
    config.add_index_field 'record_id_ss',                label: I18n.t('search.labels.record_id')
    config.add_index_field 'dcterms_title_display',       label: I18n.t('search.labels.dcterms_title')
    config.add_index_field 'dcterms_description_display', label: I18n.t('search.labels.dcterms_description'), helper_method: :truncate_index
    config.add_index_field 'collection_name_sms',         label: I18n.t('search.labels.collection'), link_to_search: true
    config.add_index_field 'repository_name_sms',         label: I18n.t('search.labels.repository'), link_to_search: true
    config.add_index_field 'dcterms_identifier_display',  label: I18n.t('search.labels.dcterms_identifier')
    config.add_index_field 'edm_is_shown_at_display',     label: I18n.t('search.labels.edm_is_shown_at'), helper_method: :linkify
    config.add_index_field 'edm_is_shown_by_display',     label: I18n.t('search.labels.edm_is_shown_by'), helper_method: :linkify
    config.add_index_field 'dcterms_creator_display',     label: I18n.t('search.labels.dcterms_creator'), link_to_search: :creator_facet
    config.add_index_field 'dc_format_display',           label: I18n.t('search.labels.dc_format'), link_to_search: :format_facet
    config.add_index_field 'dcterms_spatial_display',     label: I18n.t('search.labels.dcterms_spatial'), link_to_search: :location_facet

    # Sort Options
    config.add_sort_field 'title_sort asc', label: I18n.t('search.sort.title')
    config.add_sort_field 'collection_sort asc', label: I18n.t('search.sort.collection')
    config.add_sort_field 'created_at_dts desc', label: I18n.t('search.sort.newest')
    config.add_sort_field 'score title_sort asc', label: I18n.t('search.sort.relevance')

  end

  def show
    index
  end

end