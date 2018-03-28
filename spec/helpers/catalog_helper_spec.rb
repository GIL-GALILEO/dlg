# frozen_string_literal: true

require 'rails_helper'

describe CatalogHelper do
  describe '#rights_icon_label' do
    it 'returns label corresponding to URI' do
      uri = I18n.t('rights.by-nc-nd.uri')
      expect(rights_icon_label(uri)).to eq I18n.t('rights.by-nc-nd.label')
    end
    it 'returns the URI if lookup fails to find a label value' do
      uri = 'https://www.example.com'
      expect(rights_icon_label(uri)).to eq uri
    end
  end
  describe '#truncate_index' do
    it 'truncates a value' do
      desc = ['A' * 5_000]
      expect(helper.truncate_index(value: desc)).to eq(
        "#{'A' * (2_500 - I18n.t('search.index.truncated_field').length)}#{I18n.t('search.index.truncated_field')}"
      )
    end
  end
  describe '#spatial_cleaner' do
    it 'returns a string devoid of coordinates and "United States"' do
      value = 'United States, Georgia, Clarke County, Athens, 33.960948, -83.3779358'
      expect(spatial_cleaner(value)).to eq 'Georgia, Clarke County, Athens'
    end
    it 'does not return a blank string for "United States, 37.09024, -95.712891"' do
      value = 'United States, 37.09024, -95.712891'
      expect(spatial_cleaner(value)).to eq 'United States'
    end
  end
end