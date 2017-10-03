# frozen_string_literal: true
class CountiesController < RecordsController
  COUNTIES_FACET_FIELD = 'counties_facet'
  # include Blacklight::SearchHelper
  def index
    @counties = counties
    respond_to do |format|
      format.html
      format.json { render json: @counties }
    end
  end

  private

  # def search_builder
  #   SearchBuilder.new(RecordsController)
  # end

  def counties
    response = get_facet_field_response(COUNTIES_FACET_FIELD)
    counties_with_counts = response['facet_counts']['facet_fields'][COUNTIES_FACET_FIELD]
    counties = []
    counties_with_counts.each_with_index do |c, i|
      counties << county_object(c, counties_with_counts[i + 1]) if c.is_a? String
    end
    counties
  end

  def county_object(name, count)
    OpenStruct.new(
      name: name,
      count: count,
      link: search_action_path(search_state.add_facet_params_and_redirect(COUNTIES_FACET_FIELD, name))
    )
  end

  # return link to faceted main results page
  def search_action_url(options = {})
    search_records_path(options.except(:controller, :action))
  end

end