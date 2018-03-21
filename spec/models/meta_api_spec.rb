# frozen_string_literal: true

require 'rails_helper'

describe MetaApi do
  it 'returns a tab features object with primary and secondary attributes' do
    tab_features = MetaApi.tabs_items 4
    required_keys = %w[large_image title title_link institution institution_link short_description]
    expect(tab_features.primary).to be_a Hash
    expect(tab_features.primary.keys).to include(*required_keys)
    expect(tab_features.secondary).to be_an Array
    expect(tab_features.secondary.first.keys).to include(*required_keys)
  end
  it 'returns a carousel features array' do
    carousel_features= MetaApi.carousel_items 5
    required_keys = %w[title title_link institution institution_link]
    expect(carousel_features).to be_an Array
    expect(carousel_features.first.keys).to include(*required_keys)
  end
end