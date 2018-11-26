# frozen_string_literal: true

require 'rails_helper'

describe MetaApiV2 do
  let(:apiv2) { MetaApiV2.new }
  context 'features' do
    it 'returns a tab features object with primary and secondary attributes' do
      tab_features = apiv2.features(type: 'tab')
      # tab_features = MetaApi.tabs_items 4
      required_keys = %w[large_image title title_link institution institution_link short_description]
      expect(tab_features.primary).to be_a OpenStruct
      expect(tab_features.primary.keys).to include(*required_keys)
      expect(tab_features.secondary).to be_an OpenStruct
      expect(tab_features.secondary.first.keys).to include(*required_keys)
    end
    it 'returns a carousel features array' do
      # carousel_features = MetaApi.carousel_items 5
      # required_keys = %w[title title_link institution institution_link]
      # expect(carousel_features).to be_an Array
      # expect(carousel_features.first.keys).to include(*required_keys)
    end
  end
  context 'holding institutions' do
    it 'get holding institutions' do
      holding_institutions = apiv2.holding_institutions
      expect(holding_institutions.length).to eq 20
      expect(holding_institutions.first).to be_a OpenStruct
      expect(holding_institutions.first).to respond_to :authorized_name
    end
    it 'get holding institution' do
      holding_institution = apiv2.holding_institution('10')
      expect(holding_institution).to respond_to 'authorized_name'
      expect(holding_institution).to respond_to 'display_name'
      expect(holding_institution.image['url'])
        .to include 'record_image.jpg'
    end
  end
end