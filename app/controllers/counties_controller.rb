# frozen_string_literal: true
class CountiesController < RecordsController
  COUNTIES_FACET_FIELD = 'counties_facet'

  def index
    @counties = counties
    respond_to do |format|
      format.html
      format.json { render json: @counties }
    end
  end

  private

  def counties
    counties_with_counts = counties_facet_values
    counties = []
    counties_with_counts.each_with_index do |c, i|
      next unless c.is_a? String
      county = County.find_by_name c
      next unless county
      county.count = counties_with_counts[i + 1]
      county.href = search_action_path(search_state.add_facet_params_and_redirect(COUNTIES_FACET_FIELD, c))
      counties << county
    end
    counties
  end

  def counties_facet_values
    response = get_facet_field_response(COUNTIES_FACET_FIELD)
    response['facet_counts']['facet_fields'][COUNTIES_FACET_FIELD]
  end

  # return link to faceted main results page
  def search_action_url(options = {})
    search_records_path(options.except(:controller, :action))
  end

end