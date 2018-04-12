# frozen_string_literal: true

require 'rails_helper'

describe LinkingHelper do
  describe '#link_to_collection_page' do
    it 'shows a link to the collection with the collection name' do
      opt = {
        document: SolrDocument.new(
          id: 'test_collection',
          collection_titles_sms: ['Test Name']
        )
      }
      expect(link_to_collection_page(opt)).to(
        eq link_to 'Test Name', collection_home_path('test_collection')
      )
    end
  end
end