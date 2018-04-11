# frozen_string_literal: true
class RecordsSearch < SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  self.default_processor_chain += %i[
    add_advanced_parse_q_to_solr
    add_advanced_search_to_solr
    limit_by_collection
  ]

  def limit_by_collection(solr_parameters)
    return unless collection_specified
    solr_parameters[:fq] << "collection_record_id_sms:#{collection_specified}"
    solr_parameters['facet.field'].delete('collection_record_id_sms')
  end

  def show_only_public_records(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'display_b:1'
  end

  def show_only_dlg_records(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'portals_sms:"georgia"'
  end

  def show_only_desired_classes(solr_parameters)
    solr_parameters[:fq] ||= []
    # solr_parameters[:fq] << ''
  end

  private

  def collection_specified
    blacklight_params[:collection_record_id]
  end
end
