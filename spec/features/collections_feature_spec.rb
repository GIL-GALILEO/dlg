# frozen_string_literal: true

require 'rails_helper'

feature 'Collections' do
  before(:each) { visit search_collections_path }
  context 'search bar' do
    scenario 'uses collection search URL' do
      expect(page).to have_css("form[action='#{search_collections_url}']")
    end
    scenario 'has a placeholder indicating it searches Collections' do
      expect(page).to have_css("input[placeholder='#{I18n.t('search.bar.placeholder.collections')}']")
    end
  end
  context 'results area' do
    scenario 'defaults to list view' do
      expect(page).to have_css('a.view-type-list.active')
    end
  end
end