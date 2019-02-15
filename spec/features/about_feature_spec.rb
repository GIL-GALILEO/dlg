# frozen_string_literal: true

require 'rails_helper'

feature 'About' do
  context 'mission page' do
    before(:each) { visit about_mission_path }
    it 'has the appropriate header' do
      expect(page).to have_text 'Mission'
    end
  end
  context 'policy page' do
    before(:each) { visit about_policy_path }
    it 'has the appropriate header' do
      expect(page).to have_text 'Collection Development Policy'
    end
  end
  context 'partners and sponsors page' do
    before(:each) { visit about_partners_sponsors_path }
    it 'has the appropriate header' do
      expect(page).to have_text 'DLG Partners and Sponsors'
    end
  end
  context 'api page' do
    before(:each) { visit about_api_path }
    it 'has the appropriate header' do
      expect(page).to have_text 'DLG API'
    end
  end
end