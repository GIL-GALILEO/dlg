# frozen_string_literal: true
class ProvenancesController < RecordsController
  PIVOT_FACET_KEY = 'provenance_facet,collection_name_sms'
  PIVOT_FACET_FIELD = 'provenance_collection_facet'

  def index
    @holding_institutions = holding_institutions
    respond_to do |format|
      format.html
      format.json { render json: @holding_institutions }
    end
  end

  private

  def holding_institutions
    provenances_with_counts = provenances_pivot_facet_values
    holding_institutions = []
    provenances_with_counts.each_with_index do |p, i|
      holding_institution = OpenStruct.new(
        name: p['value'],
        count: p['count'],
        collections: collections_from_inst(p),
        href: search_action_path(search_state.add_facet_params_and_redirect(PIVOT_FACET_FIELD, p))
      )
      holding_institutions << holding_institution
    end
    holding_institutions
  end

  def provenances_pivot_facet_values
    response = get_facet_field_response(PIVOT_FACET_FIELD)
    response['facet_counts']['facet_pivot'][PIVOT_FACET_KEY]
  end

  # return link to faceted main results page
  def search_action_url(options = {})
    search_records_path(options.except(:controller, :action))
  end

  def collections_from_inst(pivot_response)
    pivot_response['pivot'].map do |c|
      state = search_state.add_facet_params_and_redirect('provenance_facet', pivot_response['value'])
      state['f']['collection_name_sms'] = [c['value']]
      link = search_action_path(state)
      OpenStruct.new(
        name: c['value'],
        count: c['count'],
        href: link
      )
    end
  end
end