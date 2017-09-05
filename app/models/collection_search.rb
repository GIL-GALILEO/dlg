class CollectionSearch < SearchBuilder

  def show_only_desired_classes(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'class_name:Collection'
  end

end