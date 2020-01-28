# frozen_string_literal: true

require 'rails_helper'

describe CollectionResourcesController do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/collections/collection_record_id/collection_resource_slug')
        .to route_to(
          'collection_resources#show',
          collection_record_id: 'collection_record_id',
          collection_resource_slug: 'collection_resource_slug'
        )
    end
  end
end