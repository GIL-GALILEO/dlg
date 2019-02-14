# frozen_string_literal: true

require 'rails_helper'

feature 'Participate' do
  context 'contribute page' do
    before(:each) { visit participate_contribute_path }
    scenario '' do
      pending('Check for some text...')
      fail
    end
  end
  context 'nominate page' do
    before(:each) { visit participate_nominate_path }
    scenario '' do
      pending('Check for a form element, a button, or some text...')
      fail
    end
  end
  context 'services page' do
    before(:each) { visit participate_partner_services_path }
    scenario '' do
      pending('Check for some text...')
      fail
    end
  end
end