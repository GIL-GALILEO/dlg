# frozen_string_literal: true

require 'rails_helper'

describe RecordsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/records').to route_to 'records#index'
    end
    it 'routes to #index with a collection record_id' do
      expect(get: '/collection/test_collection').to(
        route_to(
          'records#index',
          collection_record_id: 'test_collection'
        )
      )
    end
    context 'fulltext' do
      it 'routes to text rendering of fulltext content' do
        expect(get: '/record/test_id/fulltext.text').to(
          route_to(
            'records#fulltext',
            solr_document_id: 'test_id',
            format: 'text'
          )
        )
      end
      it 'routes to JSON rendering of fulltext content' do
        expect(get: '/record/test_id/fulltext.json').to(
          route_to(
            'records#fulltext',
            solr_document_id: 'test_id',
            format: 'json'
          )
        )
      end
    end
  end
end