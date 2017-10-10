# frozen_string_literal: true
class ProvenancesController < RecordsController
  PROVENANCE_FACET_FIELD = 'provenance_facet'

  def index
    @holding_institutions = holding_institutions
    respond_to do |format|
      format.html
      format.json { render json: @holding_institutions }
    end
  end

  private

  def holding_institutions
    provenances_with_counts = provenances_facet_values
    holding_institutions = []
    provenances_with_counts.each_with_index do |p, i|
      next unless p.is_a? String
      holding_institution = OpenStruct.new(
        name: p,
        count: provenances_with_counts[i + 1],
        href: search_action_path(search_state.add_facet_params_and_redirect(PROVENANCE_FACET_FIELD, p))
      )
      holding_institutions << holding_institution
    end
    holding_institutions
  end

  def provenances_facet_values
    response = get_facet_field_response(PROVENANCE_FACET_FIELD)
    response['facet_counts']['facet_fields'][PROVENANCE_FACET_FIELD]
  end

  # return link to faceted main results page
  def search_action_url(options = {})
    search_records_path(options.except(:controller, :action))
  end

end