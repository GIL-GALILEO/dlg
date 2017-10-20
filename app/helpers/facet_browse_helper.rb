# frozen_string_literal = true
# Common view helper methods for facet browse pages
module FacetBrowseHelper
  def active_facet_sort(field, value)
    sort = @sort_params[field] || 'count'
    sort == value ? 'btn-primary' : 'btn-default'
  end

  def sort_params
    @sort_params
  end

  def primary_sort_param
    @primary_sort_param
  end

  def secondary_sort_param
    @secondary_sort_param
  end
end