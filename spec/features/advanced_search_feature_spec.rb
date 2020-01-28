# frozen_string_literal: true

require 'rails_helper'

feature 'Advanced Searching' do
  context 'basic behaviors' do
    before :each do
      visit blacklight_advanced_search_engine.advanced_search_path
    end
    scenario 'clicking search performs a search' do
      fill_in 'metadata', with: ''
      find('#advanced-search-submit').click
      expect(page).to have_css('.document')
    end
    scenario 'entering a query and clicking search returns results' do
      fill_in 'metadata', with: 'map'
      find('#advanced-search-submit').click
      expect(page).to have_css('.document')
    end
    context 'multi-select facets', js: true do
      scenario 'exist for all facet fields' do
        expect(page).to have_css '#counties_facet_chosen'
        expect(page).to have_css '#year_facet_chosen'
        expect(page).to have_css '#type_facet_chosen'
        expect(page).to have_css '#medium_facet_chosen'
        expect(page).to have_css '#rights_facet_chosen'
        expect(page).to have_css '#collection_titles_sms_chosen'
        expect(page).to have_css '#provenance_facet_chosen'
      end
    end
  end

end