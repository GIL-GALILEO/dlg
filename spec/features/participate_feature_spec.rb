# frozen_string_literal: true

require 'rails_helper'

feature 'Participate' do
  context 'contribute page' do
    before(:each) { visit participate_contribute_path }
    it 'has the appropriate header' do
      expect(page).to have_text 'Contribute Your Collections'
    end
  end
  context 'nominate page' do
    before(:each) { visit participate_nominate_path }
    it 'has the appropriate header' do
      expect(page).to have_text 'Nominate Collections'
    end
    it 'has a Collection Name field' do
      expect(page).to have_field 'Collection Name'
    end
    it 'has a Submit Nomination button' do
      expect(page).to have_button 'Submit Nomination'
    end
  end
  context 'services page' do
    before(:each) { visit participate_partner_services_path }
    it 'has the appropriate header' do
      expect(page).to have_text 'Services For Partners'
    end
  end
end