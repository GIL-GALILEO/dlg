# frozen_string_literal: true

require 'rails_helper'

# TODO: implement webmock here
describe MetaApiV2 do
  let(:apiv2) { MetaApiV2.new }
  context 'features' do
    it 'returns an array of feature objects' do
      tab_features = apiv2.features(type: 'tab')
      required_keys = %w[primary large_image title title_link institution institution_link short_description]
      expect(tab_features.first).to respond_to(*required_keys)
    end
  end
  context 'for many holding institutions' do
    it 'returns an array of objects' do
      holding_institutions = apiv2.holding_institutions
      expect(holding_institutions.length).to eq 20
      expect(holding_institutions.first).to be_a OpenStruct
      expect(holding_institutions.first).to respond_to :authorized_name
    end
    it 'handles page param' do
      holding_institutions = apiv2.holding_institutions per_page: 25, page: 1
      p1_item_ids = holding_institutions.collect &:id
      holding_institutions_p2 = apiv2.holding_institutions per_page: 25, page: 2
      expect(holding_institutions_p2.length).to eq 25
      expect(p1_item_ids).not_to include holding_institutions_p2.first.id
    end
    it 'handles inst_type filter' do
      holding_institutions = apiv2.holding_institutions type: 'Museums'
      holding_institutions.each do |inst|
        expect(inst['institution_type']).to eq 'Museums'
      end
    end
    it 'handles letter filter' do
      holding_institutions = apiv2.holding_institutions letter: 'G'
      holding_institutions.each do |inst|
        # TODO: i should be testing display_name here - the code in dlgadmin
        # TODO: filters by authorized_name. as of 2/2019 few display_names r set
        expect(inst['authorized_name'][0]).to eq 'G'
      end
    end
  end
  context 'for a single holing institution' do
    it 'get by ID' do
      holding_institution = apiv2.holding_institution('dlg')
      expect(holding_institution).to respond_to 'authorized_name'
      expect(holding_institution).to respond_to 'display_name'
      expect(holding_institution.image['url'])
        .to include 'record_image'
    end
  end
end