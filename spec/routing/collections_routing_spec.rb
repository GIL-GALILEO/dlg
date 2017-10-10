# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/collections').to route_to 'collections#index'
    end
  end
end