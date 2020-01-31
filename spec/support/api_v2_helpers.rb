# frozen_string_literal: true

# helpful methods for mocking API requests/responses
module ApiV2Helpers
  include JSONFixtures

  def stub_all_features_request
    stub_tab_features_request
    stub_carousel_features_request
  end

  def stub_tab_features_request
    stub_request(:get, api_url('features?count=4&portal=georgia&type=tab'))
      .with(request_headers)
      .to_return(
        successful_json_response(
          json_string('api_v2_tab_features_response.json')
        )
      )
  end

  def stub_carousel_features_request
    stub_request(
      :get,
      api_url('features?count=5&portal=georgia&type=carousel')
    )
      .with(request_headers)
      .to_return(
        successful_json_response(
          json_string('api_v2_carousel_features_response.json')
        )
      )
  end

  def stub_collection_request
    stub_request(:get, api_url('collections/dlg_vsbg?portal=georgia'))
      .with(request_headers)
      .to_return(
        successful_json_response(
          json_string('api_v2_collection_response.json')
        )
      )
  end

  def stub_holding_inst_request
    stub_request(:get, api_url('holding_institutions/dlg?portal=georgia'))
      .with(request_headers)
      .to_return(
        successful_json_response(
          json_string('api_v2_holding_institution_response.json')
        )
      )
  end

  # this stub will match any request to the HIs endpoint, regardless of query
  # params
  def stub_holding_insts_request
    stub_request(:get, /holding_institutions/)
      .with(request_headers)
      .to_return(
        successful_json_response(
          json_string('api_v2_holding_institutions_response.json')
        )
      )
  end

  def stub_collection_resource_request
    stub_request(
      :get,
      api_url('collections/dlg_vsbg/resource/bibliography?portal=georgia')
    )
      .with(request_headers)
      .to_return(
        successful_json_response(
          json_string('api_v2_collection_resource_response.json')
        )
      )
  end

  def api_url(path)
    Rails.application.secrets.meta_api_url + '/' + path
  end

  def request_headers
    { headers: { 'X-User-Token' => Rails.application.secrets.meta_api_key } }
  end

  private

  def successful_json_response(body)
    {
      status: 200,
      headers: { 'Content-Type' => 'application/json' },
      body: body
    }
  end
end