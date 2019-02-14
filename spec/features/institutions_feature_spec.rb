# frozen_string_literal: true

require 'rails_helper'

feature 'Institutions' do
  before(:each) { visit institutions_path }
  context 'search bar' do
    scenario 'uses records search URL' do
      expect(page).to have_css("form[action='#{search_records_path}']")
    end
  end
  context 'institution list' do
    scenario 'lists at least 1 institution' do
      expect(page).to have_css '.institution-panel'
    end
  end
end