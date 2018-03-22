# frozen_string_literal: true

# Custom SearchBuilder for use in collection-only blacklight pages
class CollectionSearch < SearchBuilder

  def show_only_desired_classes(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'class_name_ss:Collection'
  end

end