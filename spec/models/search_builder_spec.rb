# frozen_string_literal: true

require 'rails_helper'

describe SearchBuilder do
  let(:blacklight_config) { Blacklight::Configuration.new }
  let(:scope) { double blacklight_config: blacklight_config }
  subject(:search_builder) { described_class.new scope }

  it 'sets query fq value to return only Collection records' do
    additions = %i[
      show_only_public_records
      show_only_dlg_records
      show_only_desired_classes
    ]
    expect(subject.processor_chain).to include(*additions)
  end
  it 'has blacklight maps additions' do
    expect(subject.processor_chain).to include :add_spatial_search_to_solr
  end
end