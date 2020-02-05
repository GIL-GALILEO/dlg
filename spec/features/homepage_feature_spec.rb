# frozen_string_literal: true

require 'rails_helper'

feature 'Homepage' do
  include ApiV2Helpers
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:cache) { Rails.cache }

  before(:each) do
    stub_all_features_request
  end
  context 'search bar' do
    scenario 'uses records search URL' do
      visit root_path
      expect(page).to have_css("form[action='#{search_records_path}']")
    end
  end

  context 'caching' do
    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    it 'caches tabs_features'do
      expect(cache.exist?('tabs_features')).to be(false)
      visit root_path
      expect(cache.exist?('tabs_features')).to be(true)
    end

    it 'caches carousel_features'do
      expect(cache.exist?('carousel_features')).to be(false)
      visit root_path
      expect(cache.exist?('carousel_features')).to be(true)
    end
  end
end