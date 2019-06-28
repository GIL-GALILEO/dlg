# frozen_string_literal: true

require 'rails_helper'

describe MetaApiV2 do
  include ApiV2Helpers

  let(:apiv2) { MetaApiV2.new }
  context 'features' do
    required_keys = %w[primary large_image title title_link institution institution_link short_description]
    context 'of the tab sort' do
      subject(:tab_features) do
        stub_tab_features_request
        apiv2.features type: 'tab', count: 4
      end
      it 'returns an array of feature objects for tabs' do
        expect(tab_features.length).to eq 4
        expect(tab_features.first).to respond_to(*required_keys)
      end
    end
    context 'of the carousel sort' do
      subject(:carousel_features) do
        stub_carousel_features_request
        apiv2.features type: 'carousel', count: 5
      end
      it 'returns an array of feature objects for the carousel' do
        expect(carousel_features.length).to eq 5
        expect(carousel_features.first).to respond_to(*required_keys)
      end
    end
  end
  context 'holding institutions' do
    context 'single record' do
      subject(:holding_institution) do
        stub_holding_inst_request
        apiv2.holding_institution 'dlg'
      end
      context 'for a single holing institution' do
        it 'get by ID' do
          expect(holding_institution).to respond_to 'authorized_name'
          expect(holding_institution).to respond_to 'display_name'
          expect(holding_institution.image['url'])
            .to include 'record_image'
        end
      end
    end
    context 'for many holding institutions' do
      before(:each) do
        stub_holding_insts_request
      end
      it 'returns an array of objects' do
        holding_institutions = apiv2.holding_institutions
        expect(holding_institutions.length).to eq 2
        expect(holding_institutions.first).to be_a OpenStruct
        expect(holding_institutions.first).to respond_to :authorized_name
      end
      it 'handles pagination params' do
        apiv2.holding_institutions per_page: 1, page: 1
        expect(
          a_request(:get,
                    api_url('holding_institutions?page=1&per_page=1&portal=georgia'))
            .with(request_headers)
        ).to have_been_made
      end
      it 'handles inst_type filter' do
        apiv2.holding_institutions type: 'Museums'
        expect(
          a_request(:get,
                    api_url('holding_institutions?&portal=georgia&type=Museums'))
            .with(request_headers)
        ).to have_been_made
      end
      it 'handles letter filter' do
        apiv2.holding_institutions letter: 'G'
        expect(
          a_request(:get,
                    api_url('holding_institutions?&portal=georgia&letter=G'))
            .with(request_headers)
        ).to have_been_made
      end
    end
  end
  context 'collection method' do
    subject(:collection) do
      stub_collection_request
      apiv2.collection 'dlg_vsbg'
    end
    it 'returns basic collection information' do
      expect(collection).to respond_to 'display_title'
    end
    it 'returns holding institution information' do
      expect(collection.holding_institutions.first).to have_key 'display_name'
      expect(collection.holding_institutions.first).to have_key 'image'
    end
    it 'returns holding collection resource information' do
      expect(collection.collection_resources.first).to have_key 'slug'
      expect(collection.collection_resources.first).to have_key 'title'
      expect(collection.collection_resources.first).to have_key 'position'
    end
  end
  context 'collection resource information' do
    subject(:collection_resource) do
      stub_collection_resource_request
      apiv2.collection_resource 'dlg_vsbg', 'bibliography'
    end
    it 'return collection_resource information' do
      expect(collection_resource).to respond_to :content, :position
    end
  end
end