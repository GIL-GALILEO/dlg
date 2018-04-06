# frozen_string_literal: true

require 'rails_helper'

feature 'Records' do
  before(:each) { visit search_records_path }
  context 'search bar' do
    scenario 'uses records search URL' do
      expect(page).to have_css("form[action='#{search_records_path}']")
    end
    scenario 'has a placeholder indicating it searches Collections' do
      expect(page).to have_css("input[placeholder='#{I18n.t('search.bar.placeholder.default')}']")
    end
  end
  context 'results area' do
    scenario 'defaults to gallery view' do
      expect(page).to have_css('a.view-type-gallery.active')
    end
  end
end