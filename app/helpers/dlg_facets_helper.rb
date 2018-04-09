# frozen_string_literal: true

# Common helper methods for facet-related stuff
module DlgFacetsHelper
  def boolean_facet_labels(value)
    value == 'true' ? 'Yes' : 'No'
  end

  def active_facet_sort(field, value)
    sort = @sort_params[field] || 'index'
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