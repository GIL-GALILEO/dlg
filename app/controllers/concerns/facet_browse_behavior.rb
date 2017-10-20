# frozen_string_literal: true
module FacetBrowseBehavior
  extend ActiveSupport::Concern

  included do
    include FacetBrowseHelper
    before_action :sort_facets
    before_action :set_sort_params
  end

  private

  # return link to faceted main results page
  def search_action_url(options = {})
    search_records_path(options.except(:controller, :action))
  end

  def sort_facets
    blacklight_config['facet_fields'][primary_facet_field]['sort'] = primary_facet_sort
    blacklight_config['facet_fields'][secondary_facet_field]['sort'] = secondary_facet_sort unless sort_params.is_a? String
  end

  def valid_sorts
    %w[index count]
  end

  def set_sort_params
    sort_param_names = Array.wrap(sort_params)
    @sort_params = params.permit sort_param_names
    @primary_sort_param = sort_param_names[0]
    @secondary_sort_param = sort_param_names[1] unless sort_params.is_a? String
  end
end