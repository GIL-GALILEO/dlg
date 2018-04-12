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
    it 'returns a string devoid of coordinates' do
      value = 'United States, Georgia, Clarke County, Athens, 33.960948, -83.3779358'
      expect(spatial_cleaner(value)).to eq 'United States, Georgia, Clarke County, Athens'
    end
  end
  describe '#type_cleaner' do
    it 'adds a space when appropriate' do
      expect(type_cleaner('InteractiveResource')).to eq 'Interactive Resource'
      expect(type_cleaner('StillImage')).to eq 'Still Image'
      expect(type_cleaner('MovingImage')).to eq 'Moving Image'
      expect(type_cleaner('Dataset')).to eq 'Dataset'
    end
  end
end