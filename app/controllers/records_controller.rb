# frozen_string_literal: true

# Main Blacklight search controller
class RecordsController < CatalogController
  include BlacklightMaps::ControllerOverride
  include BlacklightAdvancedSearch::Controller
  include BlacklightAdvancedSearch::RenderConstraintsOverride
  include BlacklightRangeLimit::ControllerOverride
  helper BlacklightAdvancedSearch::RenderConstraintsOverride

  rescue_from Blacklight::Exceptions::RecordNotFound do |_|
    redirect_to '/404'
  end

  before_action :set_collection, only: :index, if: :collection_limit_set?

  configure_blacklight do |config|
    config.search_builder_class = RecordsSearch

    config.default_document_solr_params = {
      fq: 'display_b: 1, portals_sms:"georgia"'
    }

    # FACETS
    config.add_facet_field :creator_facet,               label: I18n.t('search.facets.creator'), limit: true
    config.add_facet_field :subject_facet,               label: I18n.t('search.facets.subject'), limit: true
    config.add_facet_field :subject_personal_facet,      label: I18n.t('search.facets.subject_personal'), limit: true
    config.add_facet_field :location_facet,              label: I18n.t('search.facets.location'), limit: true, group: 'item', helper_method: :spatial_cleaner
    config.add_facet_field :counties_facet,              label: I18n.t('search.facets.county'), limit: true
    config.add_facet_field :year_facet,                  label: I18n.t('search.facets.year'), range: true
    config.add_facet_field :medium_facet,                label: I18n.t('search.facets.medium'), limit: true
    config.add_facet_field :type_facet,                  label: I18n.t('search.facets.type'), limit: true, helper_method: :type_cleaner
    config.add_facet_field :rights_facet,                label: I18n.t('search.facets.rights'), limit: true, helper_method: :rights_icon_label
    config.add_facet_field :collection_titles_sms,       label: I18n.t('search.facets.collection_name'), limit: true
    config.add_facet_field :provenance_facet,            label: I18n.t('search.facets.provenance'), limit: true
    config.add_facet_field :class_name,                  label: I18n.t('search.facets.record_type'), show: false


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field :dcterms_creator_display,      label: I18n.t('search.labels.dcterms_creator')
    config.add_index_field :dc_date_display,              label: I18n.t('search.labels.dc_date')
    config.add_index_field :collection_name_sms,          label: I18n.t('search.labels.collection')
    config.add_index_field :dcterms_provenance_display,   label: I18n.t('search.labels.dcterms_provenance'), link_to_search: :provenance_facet

    # Show Page Fields
    config.add_show_field :collection_titles_sms,                   label: I18n.t('search.labels.collection'), helper_method: :item_link_to_collection_page
    config.add_show_field :dcterms_title_display,                   label: I18n.t('search.labels.dcterms_title')
    config.add_show_field :dcterms_creator_display,                 label: I18n.t('search.labels.dcterms_creator'), link_to_search: :creator_facet
    config.add_show_field :dcterms_contributor_display,             label: I18n.t('search.labels.dcterms_contributor')
    config.add_show_field :dcterms_publisher_display,               label: I18n.t('search.labels.dcterms_publisher')
    config.add_show_field :dc_date_display,                         label: I18n.t('search.labels.dc_date')
    config.add_show_field :dcterms_subject_display,                 label: I18n.t('search.labels.dcterms_subject'), link_to_search: :subject_facet
    config.add_show_field :dlg_subject_personal_display,            label: I18n.t('search.labels.dlg_subject_personal'), link_to_search: :subject_personal_facet
    config.add_show_field :dcterms_spatial_display,                 label: I18n.t('search.labels.dcterms_spatial'), link_to_search: :location_facet
    config.add_show_field :dcterms_medium_display,                  label: I18n.t('search.labels.dcterms_medium'), link_to_search: :medium_facet
    config.add_show_field :dcterms_type_display,                    label: I18n.t('search.labels.dcterms_type')
    config.add_show_field :dc_format_display,                       label: I18n.t('search.labels.dc_format')
    config.add_show_field :dcterms_description_display,             label: I18n.t('search.labels.dcterms_description')
    config.add_show_field :dcterms_identifier_display,              label: I18n.t('search.labels.dcterms_identifier')
    config.add_show_field :edm_is_shown_at_display,                 label: I18n.t('search.labels.edm_is_shown_at'), helper_method: :linkify
    config.add_show_field :edm_is_shown_by_display,                 label: I18n.t('search.labels.edm_is_shown_by'), helper_method: :linkify
    config.add_show_field :dcterms_language_display,                label: I18n.t('search.labels.dcterms_language')
    config.add_show_field :dcterms_rights_holder_display,           label: I18n.t('search.labels.dcterms_rights_holder')
    config.add_show_field :dlg_local_right_display,                 label: I18n.t('search.labels.dlg_local_right')
    config.add_show_field :dcterms_bibliographic_citation_display,  label: I18n.t('search.labels.dcterms_bibliographic_citation')
    config.add_show_field :dcterms_is_part_of_display,              label: I18n.t('search.labels.dcterms_is_part_of'), helper_method: :regex_linkify
    config.add_show_field :dcterms_provenance_display,              label: I18n.t('search.labels.dcterms_provenance'), link_to_search: :provenance_facet
    config.add_show_field :dc_right_display,                        label: I18n.t('search.labels.dc_right'), helper_method: :rights_icon_tag

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, year asc', label: I18n.t('search.sort.relevance')
    config.add_sort_field 'title_sort asc', label: I18n.t('search.sort.title')
    config.add_sort_field 'year asc', label: I18n.t('search.sort.date_asc')
    config.add_sort_field 'year desc', label: I18n.t('search.sort.date_desc')
    # config.add_sort_field 'created_at_dts desc', label: I18n.t('search.sort.newest')
    config.add_sort_field 'class_name_ss asc, title_sort asc', label: I18n.t('search.sort.collections_first')

    ## define search fields

    # id
    config.add_search_field('id') do |field|
      field.include_in_simple_select = false
      field.label = I18n.t('search.labels.record_id')
      field.solr_local_parameters = {
        qf: 'record_id_ss^50000',
        pf: 'record_id_ss^50000'
      }
    end
    # title
    config.add_search_field('title') do |field|
      field.include_in_simple_select = false
      field.label = I18n.t('search.labels.dcterms_title')
      field.solr_local_parameters = {
        qf: 'title_unstem_search^1000 dcterms_title_text^50',
        pf: 'title_unstem_search^1000 dcterms_title_text^50'
      }
    end
    # description
    config.add_search_field('description') do |field|
      field.include_in_simple_select = false
      field.label = I18n.t('search.labels.dcterms_description')
      field.solr_local_parameters = {
        qf: 'description_unstem_search^1000 dcterms_description_text^50',
        pf: 'description_unstem_search^1000 dcterms_description_text^50'
      }
    end
    # collection title
    config.add_search_field('collection_name') do |field|
      field.include_in_simple_select = false
      field.label = I18n.t('search.labels.collection')
      field.solr_local_parameters = {
        qf: 'collection_titles_unstem_search^1000 collection_titles_text^50',
        pf: 'collection_titles_unstem_search^1000 collection_titles_text^50'
      }
    end
    # creator
    config.add_search_field('creator') do |field|
      field.include_in_simple_select = false
      field.label = I18n.t('search.labels.dcterms_creator')
      field.solr_local_parameters = {
        qf: 'creator_unstem_search^1000 dcterms_creator_text^500',
        pf: 'creator_unstem_search^1000 dcterms_creator_text^500'
      }
    end
    # subject
    config.add_search_field('subject') do |field|
      field.include_in_simple_select = false
      field.label = I18n.t('search.labels.dcterms_subject')
      field.solr_local_parameters = {
        qf: 'subject_unstem_search^1000 subject_personal_unstem_search^1000 dcterms_subject_text^50 dlg_subject_personal_text^50',
        pf: 'subject_unstem_search^1000 subject_personal_unstem_search^1000 dcterms_subject_text^50 dlg_subject_personal_text^50'
      }
    end
    # provenance
    config.add_search_field('provenance') do |field|
      field.include_in_simple_select = false
      field.label = I18n.t('search.labels.dcterms_provenance')
      field.solr_local_parameters = {
        qf: 'dcterms_provenance_unstem_search^1000 dcterms_provenance_text^50',
        pf: 'dcterms_provenance_unstem_search^1000 dcterms_provenance_text^50'
      }
    end
    # place
    config.add_search_field('spatial') do |field|
      field.include_in_simple_select = false
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
    config.view.maps.tileurl = 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
    config.view.maps.maxzoom = 12
    config.view.maps.show_initial_zoom = 10
    # config.show.partials << :show_maplet

    # gallery config
    config.view.gallery.partials = %i[index_header index]
    config.view.gallery.default = true
    # config.view.masonry.partials = [:index]
    # config.view.slideshow.partials = [:index]
    # config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    # config.show.partials.insert(1, :openseadragon)

    # default advanced config values
    advanced_search_facets = %w[counties_facet year_facet medium_facet
                                type_facet rights_facet collection_titles_sms
                                provenance_facet]
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    config.advanced_search[:qt] ||= 'advanced'
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'dismax'
    config.advanced_search[:form_facet_partial] ||= 'advanced_search_facets_as_select'
    config.advanced_search[:form_solr_parameters] = {
      'facet.field' => advanced_search_facets,
      'f.counties_facet.facet.limit' => -1,
      'f.year_facet.facet.limit' => 800,
      'f.medium_facet.facet.limit' => 800,
      'f.type_facet.facet.limit' => -1,
      'f.rights_facet.facet.limit' => -1,
      'f.collection_titles_sms.facet.limit' => -1,
      'f.provenance_facet.facet.limit' => -1
    }
  end

  add_show_tools_partial :reuse, partial: 'reuse'

  def collection?(_, doc)
    doc['class_name_ss'] == 'Collection'
  end

  def set_collection
    @collection = MetaApiV2.new.collection params['collection_record_id']
  end

  def collection_limit_set?
    params.key? 'collection_record_id'
  end

  def search_action_url(options = {})
    search_records_path(options.except(:controller, :action))
  end
end