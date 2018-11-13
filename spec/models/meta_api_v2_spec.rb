# frozen_string_literal: true

require 'rails_helper'

describe MetaApiV2 do
  let(:apiv2) { MetaApiV2.new }
  context 'holding institutions' do
    it 'get holding institutions' do
      holding_institutions = apiv2.holding_institutions
      expect(holding_institutions).not_to be_empty
      expect(holding_institutions.length).to eq 20
      expect(holding_institutions.first).to be_a Hash
      expect(holding_institutions.first).to have_key 'display_name'
    end
    it 'get holding institution' do
      holding_institution = apiv2.holding_institution('10')
      expect(holding_institution).not_to be_empty
    end
  end
end