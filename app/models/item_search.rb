class ItemSearch < SearchBuilder

  self.default_processor_chain += %i[limit_by_collection]

  def show_only_desired_classes(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'class_name:Item'
  end

  def limit_by_collection(solr_parameters)
    return unless collection_specified
    solr_parameters[:fq] << "collection_slug_ss:#{collection_specified}"
    solr_parameters['facet.field'].delete('collection_name_sms')
  end

  private

  def collection_specified
    blacklight_params[:item_id]
  end

end