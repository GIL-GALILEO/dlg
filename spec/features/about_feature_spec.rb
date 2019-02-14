# frozen_string_literal: true

require 'rails_helper'

feature 'About' do
  context 'mission page' do
    before(:each) { visit about_mission_path }
    scenario '' do
      pending('Check for some text...')
      fail
    end
  end
  context 'policy page' do
    before(:each) { visit about_policy_path }
    scenario '' do
      pending('Check for some text...')
      fail
    end
  end
  context 'partners and sponsors page' do
    before(:each) { visit about_partners_sponsors_path }
    scenario '' do
      pending('Check for some text...')
      fail
    end
  end
  context 'api page' do
    before(:each) { visit about_api_path }
    scenario '' do
      pending('Check for some text...')
      fail
    end
  end
end