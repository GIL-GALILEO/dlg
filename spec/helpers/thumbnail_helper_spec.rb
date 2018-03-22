# frozen_string_literal: true

require 'rails_helper'

describe ThumbnailHelper do
  include LinkingHelper
  include CatalogHelper
  let(:item_doc_with_do) do
    { 'class_name_ss' => 'Item', 'record_id_ss' => 'a_b_c',
      'edm_is_shown_by' => ['test_by_url'],
      'edm_is_shown_at' => ['test_at_url'] }
  end
  let(:item_doc_with_no_do) do
    { 'class_name_ss' => 'Item', 'record_id_ss' => 'a_b_c',
      'edm_is_shown_by' => [], 'edm_is_shown_at' => ['test_at_url'] }
  end
  context 'for collections' do
    let(:coll_doc_with_image) do
      { 'class_name_ss' => 'Collection', 'record_id_ss' => 'a_b',
        'image_ss' => 'image_url', 'edm_is_shown_at' => ['test_at_url'] }
    end
    let(:coll_doc_with_no_image) do
      { 'class_name_ss' => 'Collection', 'record_id_ss' => 'a_b',
        'image_ss' => '/dlg_default_image.png', 'thumbnail_ss' => 'do-th:',
        'edm_is_shown_at' => ['test_at_url'] }
    end
    context 'on index pages' do
      it 'renders collection thumbs from image_ss when available' do
        html = index_collection_thumb(coll_doc_with_image)
        expect(html).to(
          include('class="thumbnail"', collection_home_path('a_b'),
            coll_doc_with_image['image_ss'])
        )
        expect(html).not_to(
          include('_blank', coll_doc_with_image['edm_is_shown_at'].first,
            'do-th:')
        )
      end
      it 'uses old style collection thumbs when no image_ss available' do
        html = index_collection_thumb(coll_doc_with_no_image)
        expect(html).to(
          include('class="thumbnail"', collection_home_path('a_b'), 'do-th:')
        )
        expect(html).not_to(
          include('_blank', coll_doc_with_image['edm_is_shown_at'].first,
                  coll_doc_with_image['image_ss'])
        )
      end
    end
  end
end