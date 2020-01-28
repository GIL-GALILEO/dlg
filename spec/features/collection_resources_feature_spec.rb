# frozen_string_literal: true

require 'rails_helper'

feature 'CollectionResources' do
  include ApiV2Helpers

  context 'renders a resource page' do
    before(:each) do
      stub_collection_request
      stub_collection_resource_request
      visit resource_page_collections_path 'dlg_vsbg', 'bibliography'
    end
    scenario 'including a title and content' do
      expect(page).to have_text 'Bibliography'
      expect(page).to have_text 'Bibliographic content'
    end
    scenario 'including collection name' do
      expect(page).to have_text 'Liberty Ships'
    end
  end
end