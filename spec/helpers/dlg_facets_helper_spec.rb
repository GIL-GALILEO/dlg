# frozen_string_literal: true

require 'rails_helper'

describe DlgFacetsHelper do
  describe '#boolean_facet_labels' do
    it 'shows yes value for true' do
      expect(helper.boolean_facet_labels('true')).to match(/Yes/)
    end
    it 'shows no value for non-true values' do
      expect(helper.boolean_facet_labels('')).to match(/No/)
      expect(helper.boolean_facet_labels('false')).to match(/No/)
      expect(helper.boolean_facet_labels('0')).to match(/No/)
    end
  end
end