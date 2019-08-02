require 'rails_helper'

RSpec.describe 'JSON Endpoint', type: :request do
  # support special use case
  context '#index' do
    it 'returns a single record by record_id' do
      get '/records.json?search_field=record_id&q=gaarchives_cmf_70'
      body = JSON.parse(response.body)
      expect(body['response']['docs'].length).to eq 1
    end
    it 'returns record edm_is_shown_* values' do
      get '/records.json?search_field=record_id&q=gaarchives_cmf_70'
      body = JSON.parse(response.body)
      expect(body['response']['docs'][0]).to have_key 'edm_is_shown_at'
      expect(body['response']['docs'][0]).to have_key 'edm_is_shown_by'
    end
    it 'returns multiple records by record_id' do
      get '/records.json?search_field=record_id&q=gaarchives_cmf_70+OR+dlg_vsbg_jaj111'
      body = JSON.parse(response.body)
      expect(body['response']['docs'].length).to eq 2
    end
  end
end