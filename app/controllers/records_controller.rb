class RecordsController < CatalogController

  configure_blacklight do |config|
    config.search_builder_class = SearchBuilder

    # FACETS
    config.add_facet_field 'counties_facet',              label: 'County', limit: true, display: false, more_limit: 200, group: 'item'
    config.add_facet_field 'provenance_facet',            label: I18n.t('search.facets.provenance'), limit: true, more_limit: 200, group: 'item'
    config.add_facet_field 'subject_facet',               label: I18n.t('search.facets.subject'), limit: true, group: 'item'
    config.add_facet_field 'year_facet',                  label: I18n.t('search.facets.year'), limit: true, group: 'item'
    config.add_facet_field 'location_facet',              label: I18n.t('search.facets.location'), limit: true, group: 'item', helper_method: :spatial_cleaner
    config.add_facet_field 'rights_facet',                label: I18n.t('search.facets.rights'), limit: true, helper_method: :rights_icon_label, group: 'item'
    config.add_facet_field 'type_pivot_facet',            label: I18n.t('search.facets.medium'), limit: true, group: 'item', pivot: ['type_facet', 'medium_facet']
    config.add_facet_field 'collection_record_id_sms',    label: I18n.t('search.facets.collection'), limit: true, group: 'item'

    config.add_facet_field 'time_periods_sms',        label: I18n.t('search.facets.time_periods'), limit: true, group: 'collection'
    config.add_facet_field 'subjects_sms',            label: I18n.t('search.facets.subjects'), limit: true, group: 'collection'

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    # config.add_index_field 'record_id_ss',                label: I18n.t('search.labels.record_id')
    # config.add_index_field 'dcterms_title_display',       label: I18n.t('search.labels.dcterms_title')
    config.add_index_field 'dcterms_description_display', label: I18n.t('search.labels.dcterms_description'), helper_method: :truncate_index
    config.add_index_field 'collection_name_sms',         label: I18n.t('search.labels.collection'), helper_method: :link_to_collection_page
    config.add_index_field 'repository_name_sms',         label: I18n.t('search.labels.repository'), link_to_search: true, if: :collection?
    config.add_index_field 'edm_is_shown_at_display',     label: I18n.t('search.labels.edm_is_shown_at'), helper_method: :linkify
    config.add_index_field 'edm_is_shown_by_display',     label: I18n.t('search.labels.edm_is_shown_by'), helper_method: :linkify, unless: :collection?
    config.add_index_field 'dcterms_creator_display',     label: I18n.t('search.labels.dcterms_creator'), link_to_search: :creator_facet

    # conditional fields
    config.add_index_field 'subjects_sms',      label: 'Subject',       if: :collection?, link_to_search: true
    config.add_index_field 'time_periods_sms',  label: 'Time Periods',  if: :collection?, link_to_search: true

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

  end

  def collection?(_, doc)
    doc['class_name_ss'] == 'Collection'
  end

  def index

    if params[:county]
      params[:f] ||= {}
      params[:f]['counties_facet'] ||= []
      params[:f]['counties_facet'] << params[:county]
    end

    params.delete :county

    super
  end

end