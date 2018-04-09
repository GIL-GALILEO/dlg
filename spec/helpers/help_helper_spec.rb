# frozen_string_literal: true

require 'rails_helper'

describe HelpHelper do
  describe '#help_link' do
    it 'returns link for help modal window' do
      link = help_link('search')
      expect(link).to include help_search_path
      expect(link).to include 'data-ajax-modal="trigger"'
    end
  end
end