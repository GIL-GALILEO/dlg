# frozen_string_literal: true

require 'rails_helper'

describe ThumbnailHelper do
  describe '#thumbnail_image_tag' do
    it 'handles documents with missing or unexpected data gracefully' do
      no_thumb = '<img class="thumbnail" src="/no-thumb.png" />'
      wrong_class_doc = SolrDocument.new(class_name_ss: 'Fail')
      expect(thumbnail_image_tag(wrong_class_doc)).to eq no_thumb
      error_doc = SolrDocument.new
      expect(thumbnail_image_tag(error_doc)).to eq no_thumb
    end
  end
  describe '#sound_type_item?' do
    it 'shows sound icon if TYPE field includes SOUND' do
      doc = { 'class_name_ss': 'Item' }
      sound_doc = doc.merge 'dcterms_type_display' => %w[Sound Text]
      no_sound_doc = doc.merge 'dcterms_type_display' => %w[StillImage Text]
      wrong_class_doc = { 'class_name_ss': 'Collection' }
      expect(sound_type_item?(SolrDocument.new(sound_doc))).to be_truthy
      expect(sound_type_item?(SolrDocument.new(no_sound_doc))).to be_falsey
      expect(sound_type_item?(SolrDocument.new(doc))).to be_falsey
      expect(sound_type_item?(SolrDocument.new(wrong_class_doc))).to be_falsey
    end
  end
end