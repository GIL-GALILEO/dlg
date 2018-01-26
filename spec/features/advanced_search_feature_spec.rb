# frozen_string_literal: true

require 'rails_helper'

feature 'Advanced Searching' do
  context 'basic behaviors' do
    before :each do
      visit blacklight_advanced_search_engine.advanced_search_path
    end
    scenario 'clicking search performs a search' do
      fill_in 'all_fields', with: ''
      find('#advanced-search-submit').click
      expect(page).to have_css('.document')
    end
    scenario 'entering a query and clicking search returns results' do
      fill_in 'all_fields', with: 'map'
      find('#advanced-search-submit').click
      expect(page).to have_css('.document')
    end
  end
end