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
    it 'routes to #index with an institution slug' do
      expect(get: '/institution/test_institution').to(
        route_to(
          'records#index',
          institution_slug: 'test_institution'
        )
      )
    end
  end
end