# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecordsController do
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
  end
end