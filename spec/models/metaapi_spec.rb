# frozen_string_literal: true

require 'rails_helper'

describe MetaApi do
  it 'returns a hash for feature calls' do
    expect(MetaApi.tabs_items).to be_a_kind_of Hash
    expect(MetaApi.carousel_items).to be_a_kind_of Hash
  end
  it 'returns record info as a hash' do
    info = MetaApi.record_info('dlg_vang_mor031-001')
    expect(info).to be_a_kind_of Hash
    expect(info.keys).to include 'id', 'title', 'institution'
  end
end