# frozen_string_literal: true

require 'rails_helper'

feature 'Teach' do
  context 'using materials' do
    before(:each) { visit teach_using_materials_path }
    scenario 'has the appropriate header' do
      expect(page).to have_text 'Using DLG Materials'
    end
  end
end