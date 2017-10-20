# frozen_string_literal: true
# handle actions for Counties browse page
class CountiesController < CatalogController
  include FacetBrowseBehavior
  PRIMARY_FACET_FIELD = 'counties_facet'
  SORT_PARAMS = 'county_sort'

  configure_blacklight do |config|
    config.add_facet_field :counties_facet,
                           label: '_',
                           limit: 500,
                           display: false,
                           sort: 'count',
                           more_limit: 500
  end

  def index
    @counties = counties
    respond_to do |format|
      format.html
      format.json { render json: @counties }
    end
  end

  private

  # TODO: refactor
  def counties
    counties_with_counts = counties_facet_values
    counties = []
    counties_with_counts.each_with_index do |c, i|
      next unless c.is_a? String
      county = County.find_by_name c
      next unless county
      county.count = counties_with_counts[i + 1]
      county.href = search_action_path(
        search_state.add_facet_params_and_redirect(primary_facet_field, c)
      )
      counties << county
    end
    counties
  end

  def counties_facet_values
    response = get_facet_field_response(primary_facet_field)
    response['facet_counts']['facet_fields'][primary_facet_field]
  end

  def primary_facet_sort
    valid_sorts.include?(params[sort_params]) ? params[sort_params] : 'count'
  end

  def primary_facet_field
    PRIMARY_FACET_FIELD
  end

  def sort_params
    SORT_PARAMS
  end
end