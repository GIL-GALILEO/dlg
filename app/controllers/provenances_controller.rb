# frozen_string_literal: true
# handle actions for Holding Institution browse page
class ProvenancesController < CatalogController
  include FacetBrowseBehavior
  PIVOT_FACET_KEY = 'provenance_facet,collection_name_sms'
  FACET_FIELD = 'provenance_collection_facet'
  PRIMARY_FACET_FIELD = 'provenance_facet'
  SECONDARY_FACET_FIELD = 'collection_name_sms'
  SORT_PARAMS = %w[inst_sort coll_sort].freeze

  configure_blacklight do |config|
    config.add_facet_field :provenance_facet,
                           label: '_',
                           limit: 200,
                           more_limit: 200,
                           show: false,
                           sort: 'count'
    config.add_facet_field :collection_name_sms,
                           label: '_',
                           limit: 200,
                           more_limit: 200,
                           show: false,
                           sort: 'count'
    config.add_facet_field :provenance_collection_facet,
                           label: '_',
                           limit: 200,
                           more_limit: 200,
                           show: false,
                           pivot: %w[provenance_facet collection_name_sms]

  end

  def index
    @holding_institutions = holding_institutions
    respond_to do |format|
      format.html
      format.json { render json: @holding_institutions }
    end
  end

  private

  def holding_institutions
    provenances_pivot_facet_values.map { |p| build_holding_institution p }
  end

  def build_holding_institution(prov)
    OpenStruct.new(
      name: prov['value'],
      count: prov['count'],
      collections: collections_from_inst(prov),
      href: search_action_path(
        search_state.add_facet_params_and_redirect(FACET_FIELD,prov)
      )
    )
  end

  def provenances_pivot_facet_values
    response = get_facet_field_response(FACET_FIELD)
    response['facet_counts']['facet_pivot'][PIVOT_FACET_KEY]
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

  def primary_facet_sort
    valid_sorts.include?(params[sort_params[0]]) ? params[sort_params[0]] : 'count'
  end

  def primary_facet_field
    PRIMARY_FACET_FIELD
  end

  def secondary_facet_sort
    valid_sorts.include?(params[sort_params[1]]) ? params[sort_params[1]] : 'count'
  end

  def secondary_facet_field
    SECONDARY_FACET_FIELD
  end

  def sort_params
    SORT_PARAMS
  end
end