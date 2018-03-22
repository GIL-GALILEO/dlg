# frozen_string_literal: true

require 'rails_helper'

describe LinkingHelper do
  describe '#rights_icon_label' do
    it 'returns label corresponding to URI' do
      uri = I18n.t('rights.by-nc-nd.uri')
      expect(helper.rights_icon_label(uri)).to eq I18n.t('rights.by-nc-nd.label')
    end
    it 'returns the URI if lookup fails to find a label value' do
      uri = 'https://www.example.com'
      expect(helper.rights_icon_label(uri)).to eq uri
    end
  end

  describe '#link_to_collection_page' do
    it 'shows a link to the collection with the collection name' do
      opt = {
        document: {
          id: 'test_collection',
          collection_name_sms: ['Test Name']
        }
      }
      expect(link_to_collection_page(opt)).to(
        eq link_to 'Test Name', collection_home_path('test_collection')
      )
    end
  end
end