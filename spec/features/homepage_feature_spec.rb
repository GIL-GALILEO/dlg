# frozen_string_literal: true

require 'rails_helper'

feature 'Homepage' do
  include ApiV2Helpers

  before(:each) do
    stub_all_features_request
    visit root_path
  end
  context 'search bar' do
    scenario 'uses records search URL' do
      expect(page).to have_css("form[action='#{search_records_path}']")
    end
  end
end