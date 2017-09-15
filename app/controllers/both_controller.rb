class BothController < CatalogController

  configure_blacklight do |config|
    config.search_builder_class = SearchBuilder

    # FACETS
    config.add_facet_field 'provenance_facet',        label: I18n.t('search.facets.provenance'), limit: true, group: 'item'
    config.add_facet_field 'subject_facet',           label: I18n.t('search.facets.subject'), limit: true, group: 'item'
    config.add_facet_field 'year_facet',              label: I18n.t('search.facets.year'), limit: true, group: 'item'
    config.add_facet_field 'location_facet',          label: I18n.t('search.facets.location'), limit: true, group: 'item'
    config.add_facet_field 'rights_facet',            label: I18n.t('search.facets.rights'), limit: true, helper_method: :rights_icon_label, group: 'item'
    config.add_facet_field 'medium_facet',            label: I18n.t('search.facets.medium'), limit: true, group: 'item'
    config.add_facet_field 'collection_name_sms',     label: I18n.t('search.facets.collection'), limit: true, group: 'item'

    config.add_facet_field 'time_periods_sms',        label: I18n.t('search.facets.time_periods'), limit: true, group: 'collection'
    config.add_facet_field 'subjects_sms',            label: I18n.t('search.facets.subjects'), limit: true, group: 'collection'

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    # config.add_index_field 'record_id_ss',                label: I18n.t('search.labels.record_id')
    # config.add_index_field 'dcterms_title_display',       label: I18n.t('search.labels.dcterms_title')
    config.add_index_field 'dcterms_description_display', label: I18n.t('search.labels.dcterms_description'), helper_method: :truncate_index
    config.add_index_field 'collection_name_sms',         label: I18n.t('search.labels.collection'), link_to_search: true
    config.add_index_field 'repository_name_sms',         label: I18n.t('search.labels.repository'), link_to_search: true, if: :collection?
    config.add_index_field 'edm_is_shown_at_display',     label: I18n.t('search.labels.edm_is_shown_at'), helper_method: :linkify
    config.add_index_field 'edm_is_shown_by_display',     label: I18n.t('search.labels.edm_is_shown_by'), helper_method: :linkify, unless: :collection?
    config.add_index_field 'dcterms_creator_display',     label: I18n.t('search.labels.dcterms_creator'), link_to_search: :creator_facet

    # conditional fields
    config.add_index_field 'subjects_sms',      label: 'Subject',       if: :collection?
    config.add_index_field 'time_periods_sms',  label: 'Time Periods',  if: :collection?

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'title_sort asc', label: I18n.t('search.sort.title')
    config.add_sort_field 'created_at_dts desc', label: I18n.t('search.sort.newest')
    config.add_sort_field 'score title_sort asc', label: I18n.t('search.sort.relevance')

  end

  def collection?(_, doc)
    doc['class_name_ss'] == 'Collection'
  end

end