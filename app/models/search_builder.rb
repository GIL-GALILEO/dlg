# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  self.default_processor_chain += %i[
    show_only_public_records
    show_only_dlg_records
    show_only_desired_classes
  ]

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
    solr_parameters[:fq] << ''
  end
end
