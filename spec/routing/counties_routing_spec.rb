# frozen_string_literal: true

require 'rails_helper'

describe CountiesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/counties').to route_to 'counties#index'
    end
  end
end